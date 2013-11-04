fs = require 'fs'
http = require 'http'
socketio = require 'socket.io'

server = http.createServer (req, res) ->
  res.writeHead
    "Content-type": "text/plain"

  if req.url == '/'
    staticResponse "public/index.html", res

  else if req.url == "/favicon.ico"
    staticResponse "public/favicon.jpeg", res
  else
    throw "no such resource"


staticResponse = (fileName, res) ->
  fs.readFile fileName, (err, data) ->
    throw err if err
    res.write data
    res.end()




server.listen 3000
io = socketio.listen(server)

io.sockets.on 'connection', (socket) ->
  console.log 'Socket connected!'

  socket.on 'message', (data) ->
    console.log data
    socket.emit 'echo', data

  setInterval () ->
    socket.emit 'pushedMessage', "THIS IS A REMINDERP"
  , 5000
