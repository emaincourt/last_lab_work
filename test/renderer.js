const sinon = require('sinon');
const pug = require('pug');
const should = require('should');
const fs = require('fs');
const renderer = require('../lib/renderer');

describe('renderer -> renderFile', () => {
    it('renders a non-pug file', async () => {
        const mock = sinon.mock(fs);
        mock.expects('readFileSync')
            .once()
            .withArgs('public/anyType/anyFilename')
            .returns(true);
        should.equal(
            await renderer.render('anyFilename', 'anyType'),
            true,
        );
        mock.verify();
        mock.restore();
    });

    it('renders a pug file', async (done) => {
        const mock = sinon.mock(pug);
        mock.expects('renderFile')
            .once()
            .withArgs('public/pug/anyFilename')
            .returns(Promise.resolve(true) && done());
        should.equal(
            await renderer.render('anyFilename', 'pug'),
            true,
        );
        mock.verify();
        mock.restore();
    });
});
