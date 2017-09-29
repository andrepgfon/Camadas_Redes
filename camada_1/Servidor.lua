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

print("Mensagem : " .. reply)

conexao:close()
