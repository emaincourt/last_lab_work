sinon = require 'sinon'
http = require 'http'
should = require 'should'
server = require '../lib/server'

describe 'http -> createServer', () ->
    it 'it creates the server', () ->
        spy = sinon.spy http, 'createServer'
        require '../lib'
        should.equal spy.getCall(0).args[0], server.logic
        spy.restore()