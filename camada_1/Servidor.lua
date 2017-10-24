function toASCII(string)
	retorno = ""
	i = 1
	while (i<string.len(string)) do
		retorno = retorno .. string.char(tonumber(string.sub(string,i,(8+i)-1), 2))
		i = i+8
	end
	return retorno
end


local socket = require("socket")

local server = assert(socket.bind("192.168.56.1", 0)) 		--"amarra" a variavel socket ao localhost e, nesse caso, a qualquer porta que o sistema quiser disponibilizar

local ip, port = server:getsockname()

print("Conecte ao endereco 192.168.56.1 na porta " .. port)

local conexao = assert(server:accept())

print("Recebendo o pedido de tamanho")

reply = conexao:receive("*l");

-- Recebendo o tamanho dos pacotes
if reply == "Tamanho" then
	print("Pedido de tamanho recebido, enviando tamanho")
	conexao:send("96\n")							--arbitrario, poderia ser qualquer tamanho, nesse caso foi escolhido 12 bytes
	print("Tamanho enviado")
else
	conexao:close()
end

-- Iniciando o recebimento de pacotes
reply = conexao:receive("*a") -- recebe o pacote até terminar o envio

-- Separando as partes para serem mostradas
-- TALVEZ ISSO NÃO SEJA MAIS NECESSÁRIO DEPOIS QUE COLOCAR A CAMADA DE APLICAÇÃO
local preambule = string.sub(reply,1,56)
local frame_delimiter = string.sub(reply,57,64)
local mac_destination = string.sub(reply,65,112)
local mac_source = string.sub(reply,113,160)
local tag = string.sub(reply,161,192)
local ethertype = string.sub(reply,193,208)
local payload = string.sub(reply,209,568)
local frame_check_sequence = string.sub(reply,569,600)
local interpacket_gap = string.sub(reply,601,696)


print("---------PARTES DO QUADRO RECEBIDO---------")

print("Preambulo: " .. preambule)
print("Delimitador: " .. frame_delimiter)
print("Mac de destino: " .. mac_destination)
print("Mac da fonte: " .. mac_source)
print("Tag: " .. tag)
print("Ethertype: " .. ethertype)
print("Payload: " .. payload)
print("Frame check sequence: " .. frame_check_sequence)
print("Interpacket gap: " .. interpacket_gap)


print("----------MENSAGEM----------\n" .. toASCII(reply))

conexao:close()
