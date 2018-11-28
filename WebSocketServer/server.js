var WebSocketServer = require('websocket').server;
var http = require('http');
var fs = require('fs');


var server = http.createServer(function(request, response) {
  // process HTTP request. Since we're writing just WebSockets
  // server we don't have to implement anything.
  fs.readFile('./index.html', 'utf-8', function(error, content) {

    response.writeHead(200, {"Content-Type": "text/html"});

    response.end(content);

    });
});

server.listen(1337, function() { });

// create the server
wsServer = new WebSocketServer({
  httpServer: server
});

// WebSocket server
wsServer.on('request', function(request) {
  var socket = request.accept(null, request.origin);
    console.log("new user")
    //console.log(wsServer.connections[0].socket);
  // This is the most important callback for us, we'll handle
  // all messages from users here.
    socket.on('message', function(message) {
      //console.log("message:",message);
    if (message.type === 'utf8') {
      // process WebSocket message
        wsServer.connections.filter(connection => socket != connection && connection.connected && connection.state == 'open')
        .forEach(connection => {
            connection.send(message.utf8Data);
        });
    }
  });

  socket.on('close', function(connection) {
    // close user connection
  });
});