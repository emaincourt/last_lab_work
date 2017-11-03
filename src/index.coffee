http = require 'http'
server = require './server'

http.createServer(server.logic).listen server.port, server.address
