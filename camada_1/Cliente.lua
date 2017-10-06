local MAX_TAM = 1000;

function toBits(num)
  alg = tonumber(num)
	print (alg)
	-- returns a table of bits, least significant first.
    local t={} -- will contain the bits
    while alg > 0 do
        rest=math.fmod(alg ,2)
		print(rest)
        t[#t+1]=rest
        alg=(alg -rest)/2
    end
    return t
end

function numberstring(number)
   local s = ""
   repeat
      local remainder = math.fmod(number,2)
      s = remainder..s
      number = (number-remainder)/2
   until number==0
   return s
end

require('socket')

io.write "Escolha um servidor > " ;

local servidor = io.read();

io.write("Escolha uma porta > ");

local porta = io.read();

local Vcliente = socket.connect(servidor, porta);

if Vcliente then
	io.write("Conectado com sucesso!\n");
end

io.write("Digite o nome do arquivo: ")
local filename = io.read()

local file = assert(io.open(filename, 'r'))

local data = file:read('*all') -- Message

-- Simulating package lose
math.randomseed(os.time())
packet_lose_chance = math.random() % 10

while(packet_lose_chance < 1) then -- 10% de chance de perda de pacote
  print("PACOTE PERDIDO \"NO \"CAMINHO ")
  print("TENTANDO NOVAMENTE")
end
Vcliente:send(data)

Vcliente:close()
