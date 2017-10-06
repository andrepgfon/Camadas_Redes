local socket = require("socket")				--funcao "magica" que reconhece a
												--biblioteca a ser utilizada e a encontra no computador
local server = assert(socket.bind("*", 0)) 		--"amarra" a variavel socket ao localhost e, nesse caso,
												--a qualquer porta que o sistema quiser disponibilizar

local ip, port = server:getsockname()			--retorna a informacao de endereco associada ao objeto
												--server(IP e porta)

print("Conecte ao endereco localhost na porta " .. port)--nos fala a real

local conexao = assert(server:accept())			--espera um cliente se conectar ao objeto server e
												--retorna um objeto cliente ao qual server esta
												--conectado

reply = conexao:receive('*a');				--tenta receber dados de um objeto cliente chamado Vcliente

local preambule = reply[0-55]
local frame_delimiter = reply[56-63]
local mac_destination = reply[64-111]
local mac_source = reply[112-159]
local tag = reply[160-191]
local ethertype = reply[192-207]
local payload = reply[208-567]
local frame_check_sequence = [568-599]
local interpacket_gap = [600-695]

print("Preambulo: " .. preambule)
print("Delimitador: " .. frame_delimiter)
print("Mac de destino: " .. mac_destination)
print("Mac da fonte: " .. mac_source)
print("Tag: " .. tag)
print("Ethertype: " .. ethertype)
print("Payload: " .. payload)
print("Frame check sequence: " .. frame_check_sequence)
print("Interpacket gap: " .. interpacket_gap)


print("Mensagem : " .. reply)

conexao:close()
