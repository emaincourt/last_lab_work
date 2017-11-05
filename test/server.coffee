should = require 'should'
fs = require 'fs'
sinon = require 'sinon'
url = require 'url'
server = require '../lib/server'
renderer = require '../lib/renderer'

sandbox = null

beforeEach () ->
    sandbox = sinon.sandbox.create()

afterEach () ->
    sandbox.restore()

describe 'server -> logic', () ->
    it 'is well configured', () ->
        should.equal server.address, "127.0.0.1"
        should.equal server.port, "8888"

    it 'parses the url and redirects to the right file', () ->
        mocks =
            renderer: sandbox.mock(renderer)
            fs: sandbox.mock(fs),
        mocks.fs.expects('existsSync')
            .once()
            .withArgs('public/pug/index.pug')
            .returns(true)
        mocks.renderer.expects('render')
            .once()
            .withArgs('index.pug', 'pug')
            .resolves('FileContent')
        req =
            url: 'http://localhost:8888/'
        res =
            writeHead: (status) -> should.equal status, 200
            write: (content) -> should.equal content, 'FileContent'
            end: () -> {}
        spyEnd = sandbox.spy res, 'end'
        server.logic(req, res).then(() ->
            should.equal spyEnd.called, true
            mocks.fs.verify()
            mocks.renderer.verify()
            spyEnd.restore()
            Object.keys(mocks).forEach((mock) -> mocks[mock].restore())
        )

    it 'resolves the root directory if none can be found', () ->
        mocks =
            renderer: sandbox.mock(renderer)
            fs: sandbox.mock(fs)
        mocks.fs.expects('existsSync')
            .once()
            .withArgs('public/pug/index.pug')
            .returns(true)
        mocks.renderer.expects('render')
            .once()
            .withArgs('index.pug', 'pug')
            .resolves('FileContent')
        req =
            url: 'http://localhost:8888'
        res =
            writeHead: (status) -> should.equal status, 200
            write: (content) -> should.equal content, 'FileContent'
            end: () -> {}
        spyEnd = sandbox.spy res, 'end'
        server.logic(req, res).then(() ->
            should.equal spyEnd.called, true
            mocks.fs.verify()
            mocks.renderer.verify()
            spyEnd.restore()
            Object.keys(mocks).forEach((mock) -> mocks[mock].restore())
        )

describe 'server -> logic#errors', () ->
    it 'only serves files that is are known templates or part of the public directory', () ->
        req =
            url: 'http://localhost:8888/forbidden/wrong.css'
        res =
            writeHead: (status) =>
                should.equal status, 404
            end: () -> {}
        spyEnd = sandbox.spy res, 'end'
        server.logic(req, res)
        spyEnd.restore()

    it 'returns a 500 error if the error can not be identified', () ->
        urlMock = sandbox.mock url
        urlMock.expects('parse')
            .once()
            .withArgs('http://localhost:8888/forbidden/wrong.css')
            .throws('Error')
        req =
            url: 'http://localhost:8888/forbidden/wrong.css'
        res =
            writeHead: (status) => should.equal status, 500
            end: () => {}
        spyEnd = sandbox.spy res, 'end'
        spyEnd.restore()
        urlMock.restore()

    it 'returns a 404 error if the file can not be found', () ->
        fsMock = sandbox.mock fs
        fsMock.expects('existsSync')
            .once()
            .withArgs('public/pug/index.pug')
            .returns(false)
        req =
            url: 'http://localhost:8888'
        res =
            writeHead: (status) => should.equal status, 404
            end: () => {}
        spyEnd = sandbox.spy res, 'end'
        server.logic(req, res)
        spyEnd.restore()
        fsMock.restore()
