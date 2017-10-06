function toBits(number)
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

local data = file:read('*all')
local payload = ""

-- Simulating package loss
math.randomseed(os.time())
packet_lose_chance = math.random() % 10

	--if(packet_lose_chance < 5) then
	--else
	local i
	for i=1,string.len(data) do
		local bits = toBits(string.byte(data, i))
		while(string.len(bits) < 8) do
			bits = "0" .. bits
		end
		payload = payload .. bits
	end
	Vcliente:send(payload)
	--end
Vcliente:close()
