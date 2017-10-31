http = require 'http'
server = require './server.coffee'

http.createServer(server.logic).listen server.port, server.address
