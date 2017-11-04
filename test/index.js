const sinon = require('sinon');
const http = require('http');
const should = require('should');
const server = require('../lib/server');

describe('http -> createServer', () => {
    it('it creates the server', () => {
        const spy = sinon.spy(http, 'createServer');
        require('../lib');
        should.equal(spy.getCall(0).args[0], server.logic);
        spy.restore()
    });
});