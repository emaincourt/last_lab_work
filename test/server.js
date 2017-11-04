const should = require('should');
const fs = require('fs');
const sinon = require('sinon');
const url = require('url');
const server = require('../lib/server');
const renderer = require('../lib/renderer')

describe('server -> logic', async () => {
    it('is well configured', () => {
        should.equal(server.address, "127.0.0.1");
        should.equal(server.port, "8888");
    });

    it('parses the url and redirects to the right file', async () => {
        const mocks = {
            'renderer': sinon.mock(renderer),
            'fs': sinon.mock(fs),
        }
        mocks['fs'].expects('existsSync')
            .once()
            .withArgs('public/pug/index.pug')
            .returns(true);
        mocks['renderer'].expects('render')
            .once()
            .withArgs('index.pug', 'pug')
            .resolves('FileContent');
        const req = { url: 'http://localhost:8888/' };
        const res = {
            writeHead: (status) => should.equal(status, 200),
            write: (content) => should.equal(content, 'FileContent'),
            end: () => {},
        };
        const spyEnd = sinon.spy(res, 'end');
        await server.logic(req, res);
        should.equal(spyEnd.called, true);
        mocks['fs'].verify();
        mocks['renderer'].verify();
        spyEnd.restore();
        Object.keys(mocks).forEach(mock => mocks[mock].restore());
    });

    it('resolves the root directory if none can be found', async () => {
        const mocks = {
            'renderer': sinon.mock(renderer),
            'fs': sinon.mock(fs),
        }
        mocks['fs'].expects('existsSync')
            .once()
            .withArgs('public/pug/index.pug')
            .returns(true);
        mocks['renderer'].expects('render')
            .once()
            .withArgs('index.pug', 'pug')
            .resolves('FileContent');
        const req = { url: 'http://localhost:8888' };
        const res = {
            writeHead: (status) => should.equal(status, 200),
            write: (content) => should.equal(content, 'FileContent'),
            end: () => {},
        };
        const spyEnd = sinon.spy(res, 'end');
        await server.logic(req, res);
        should.equal(spyEnd.called, true);
        mocks['fs'].verify();
        mocks['renderer'].verify();
        spyEnd.restore();
        Object.keys(mocks).forEach(mock => mocks[mock].restore());
    });
});

describe('server -> logic#errors', () => {
    it('only serves files that is are known templates or part of the public directory', async () => {
        const req = { url: 'http://localhost:8888/forbidden/wrong.css' };
        const res = {
            writeHead: (status) => should.equal(status, 404),
            end: () => {},
        };
        const spyEnd = sinon.spy(res, 'end');
        await server.logic(req, res);
        should.equal(spyEnd.getCall(0).args[0], 'Error 404: not found');
        spyEnd.restore();
    });

    it('returns a 500 error if the error can not be identified', async () => {
        const urlMock = sinon.mock(url);
        urlMock.expects('parse')
            .once()
            .withArgs('http://localhost:8888/forbidden/wrong.css')
            .throws('Error');
        const req = { url: 'http://localhost:8888/forbidden/wrong.css' };
        const res = {
            writeHead: (status) => should.equal(status, 500),
            end: () => {},
        };
        const spyEnd = sinon.spy(res, 'end');
        await server.logic(req, res);
        should.equal(spyEnd.getCall(0).args[0], 'Oops');
        spyEnd.restore();
        urlMock.restore();
    });

    it('returns a 404 error if the file can not be found', async () => {
        const fsMock = sinon.mock(fs);
        fsMock.expects('existsSync')
            .once()
            .withArgs('public/pug/index.pug')
            .returns(false);
        const req = { url: 'http://localhost:8888' };
        const res = {
            writeHead: (status) => should.equal(status, 404),
            end: () => {},
        };
        const spyEnd = sinon.spy(res, 'end');
        await server.logic(req, res);
        spyEnd.restore();
        fsMock.restore();
    });
});
