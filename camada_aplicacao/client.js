if(!process.argv[2] || !process.argv[3]) {
    return console.log('Uso: node client.js <servidor> <arquivo>');
}

var server = process.argv[2];
var file = process.argv[3];

const net = require('net');

const client = net.createConnection({ port: 80, host: server }, () => {
    
    client.write('\
GET /' + file + ' HTTP/1.1\r\n\
User-Agent: Mozilla/4.0 (compatible; MSIE5.01; Windows NT)\r\n\
Host: ' + server + '\r\n\
Accept-Language: pt-br\r\n\
Accept-Encoding: gzip, deflate\r\n\
Connection: Keep-Alive\r\n');

});
client.on('data', (data) => {
    console.log(data.toString());
    client.end();
});