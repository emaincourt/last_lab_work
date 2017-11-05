sinon = require 'sinon'
pug = require 'pug'
should = require 'should'
fs = require 'fs'
renderer = require '../lib/renderer'

sandbox = null

beforeEach () ->
    sandbox = sinon.sandbox.create()

afterEach () ->
    sandbox.restore()

describe 'renderer -> renderFile', () ->
    it 'renders a non-pug file', () ->
        mock = sandbox.mock fs
        mock.expects('readFileSync')
            .once()
            .withArgs('public/anyType/anyFilename')
            .returns(true)
        renderer.render('anyFilename', 'anyType').then((res) ->
            should.equal res, true
            mock.verify()
            mock.restore()
        )

    it 'renders a pug file', () ->
        mock = sandbox.mock pug
        mock.expects('renderFile')
            .once()
            .withArgs('public/pug/anyFilename')
            .returns(true)
        renderer.render('anyFilename', 'pug').then((res) ->
            should.equal res, true
            mock.verify()
            mock.restore()
        )
