function toBits(number)
   local s = ""
   repeat
      local remainder = math.fmod(number,2)
      s = remainder..s
      number = (number-remainder)/2
   until number==0
   return s
end

local socket = require("socket")

local CServer = assert(socket.bind("*", 3000))


local ip, port = CServer:getsockname()


print("Conecte ao endereco "..ip.." na porta " .. port)

local conexao = assert(CServer:accept())

data = conexao:receive('*a')

conexao:close()

print(data)

-- ESSA PARTE VAI TER QUE SER AUTOMÃTICA POIS O IP E PORTA SERÃƒO PASSADOS NO BROWSER ----
io.write ("Escolha um servidor > ") ;

local servidor = io.read();

io.write("Escolha uma porta > ");

local porta = io.read();

-----------------------------------------------------------------------------------------

local Vcliente = socket.connect(servidor, porta);

if Vcliente then
	io.write("Conectado com sucesso!\n");
end

print("Enviando o tamanho")
Vcliente:send("Tamanho\n")					--tamanho maximo a ser recebido de uma vez

tamanho = Vcliente:receive("*l")			--recebe o tamanho maximo definido pelo servidor, para ser usado na construcao do frame
print("String Tamanho recebida")
io.write("Digite o nome do arquivo: ")

--local filename = io.read()
--local file = assert(io.open(filename, 'r'))


-- AQUI LÃŠ-SE O ARQUIVO QUE SERÃ ENVIADO. NO CASO DA CAMADA DE APLICAÃ‡ÃƒO VAI SER UMA REQUISIÃ‡ÃƒO
--local data = file:read('*all')


local payload = ""

print("PDU Original: " .. data)

-- Simulando perda de "pacote"
math.randomseed(os.time())
packet_lose_chance = math.random() % 10

-- Convertendo PDU para binÃ¡rio de 8 bits cada palavra
local i
for i=1,string.len(data) do											--percorre data
	local bits = toBits(string.byte(data, i))						--armazena em bits os nÃºmeros transformados em bits que estiverem em data
	while(string.len(bits) < 8) do									--concatena 0 a esquerda de bits enquanto nÃ£o tiver o tamanho 8
		bits = "0" .. bits
	end
	payload = payload .. bits										--concatena bits com payload
end

print("PDU convertida para binario e enviada: " .. payload)

-- Enviando o trem
i = 1
while (i<string.len(payload)) do 									--enquanto i for menor que o tamanho total de payload
	local partialPayload = string.sub(payload,i,(tamanho+i)-1)  	--atribui a partialPayload uma substring de payload que comeÃ§a em i e termina em
	while(true) do
		if(packet_lose_chance < 2) then
			print("Pacote Perdido!")
			socket.sleep(math.random()%5)
		else														--(tamanho+i-1), que tem o tamanho "tamanho"(como i comeca valendo 1)
			Vcliente:send(partialPayload)
			break
		end															--envia o conteudo de partialPayload ao cliente
		packet_lose_chance = (packet_lose_chance + math.random()) % 10
	end
	i = i+tamanho													--faz i comeÃ§ar no prÃ³ximo "frame"
end





socket.sleep(10)

Vcliente:close()
