require('socket')

io.write "Escolha um servidor > " ;

local servidor = io.read();							--serve pra me irritar e
												--eu ter que digitar localhost toda vez que eu for testar

io.write("Escolha uma porta > ");

local porta = io.read();								--grava em porta a porta em que se deseja conectar

local Vcliente = socket.connect(servidor, porta);		--tenta conectar Vcliente a um host "remoto",
												--retornando e guardando em Vcliente um objeto cliente
												--(capaz de executar certas funcoes)

if Vcliente then								--caso Vcliente nao seja nulo, faca o seguinte
	io.write("Conectado com sucesso!\n");
end

io.write("Digite o nome do arquivo: ")
local filename = io.read()

local file = assert(io.open(filename, 'r')) 		--abre b.txt em modo de leitura

local data = file:read('*all')						--Le conteudo de b.txt

-- Simulating package lose
math.randomseed(os.time())
packet_lose_chance = math.random() % 10

if(packet_lose_chance < 5) then
  print("PACOTE PERDIDO \"NO CAMINHO\".")
else
  Vcliente:send(data)
end

Vcliente:close()
