const net = require('net');
const fs = require('fs');

const htdocs = '..';

const server = net.createServer((c) => {
    c.on('data', (data) => {
        let parsedData = data.toString('utf8').split(' ');
        let file = parsedData[1];
        let fileData = fs.readFileSync(htdocs + file);
        let stats = fs.statSync(htdocs + file);

        c.write('\
HTTP/1.1 200 OK\r\n\
Date: ' + new Date().toUTCString() + '\r\n\
Server: Node.js\r\n\
Last-Modified: ' + new Date(stats.mtime).toUTCString() + '\r\n\
Accept-Ranges: bytes\r\n\
Content-Length: ' + stats.size + '\r\n\
Content-Type: text/html\r\n\n' + fileData);

    });
});
server.listen(80, () => {

});