require './support/test_helper'
_ = require 'lodash'
Client = require '../lib/client'
librato = require '..'

describe 'librato', ->
  beforeEach ->
    librato.configure email: 'foo@example.com', token: 'foobar'
    sinon.stub(Client::, 'send').callsArg(1)

  describe '::increment', ->

    it 'defaults increment to 1', ->
      librato.increment('messages')
      librato.flush()
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      values = _(args[0].gauges).pluck('value').value()
      expect(names).to.contain 'messages'
      expect(values).to.contain 1

    it 'can increment more than 1', ->
      librato.increment('messages', 2)
      librato.flush()
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      values = _(args[0].gauges).pluck('value').value()
      expect(names).to.contain 'messages'
      expect(values).to.contain 2

    it 'translates unsupported metric characters to underscores', ->
      librato.increment('this/is/:a/(test?!)')
      librato.flush()
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      values = _(args[0].gauges).pluck('value').value()
      expect(names).to.contain 'this_is_:a_test_'

    it 'accepts a custom source', ->
      librato.increment('messages', {source: 'source1'})
      librato.increment('messages', {source: 'source2'})
      librato.flush()
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      sources = _(args[0].gauges).pluck('source').value()
      values = _(args[0].gauges).pluck('value').value()
      expect(names).to.eql ['messages', 'messages']
      expect(values).to.eql [1, 1]
      expect(sources).to.eql ['source1', 'source2']

  describe '::timing', ->
    describe 'with a synchronous function', ->
      it 'does not throw', ->
        expect(-> librato.timing('foobar', (->))).not.to.throwError()

      describe 'with a custom source', ->
        it 'does not throw', ->
          expect(-> librato.timing('foobar', source: 'source', ((cb) ->))).not.to.throwError()

    describe 'with an asynchronous function', ->
      it 'does not throw', ->
        expect(-> librato.timing('foobar', ((cb) ->))).not.to.throwError()

  describe '::measure', ->
    it 'does not throw', ->
      expect(-> librato.measure('foobar', 1)).not.to.throwError()

    it 'translates unsupported metric characters to underscores', ->
      librato.measure('this/is/:a/(test?!)2', 1)
      librato.flush()
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      expect(names).to.contain 'this_is_:a_test_2'

  describe '::flush', ->
    beforeEach ->
      librato.increment('foo')
      librato.measure('bar', 1)
      librato.flush()

    it 'sends data to Librato', ->
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      expect(names).to.contain 'foo'
      expect(names).to.contain 'bar'

    it 'does not post data to Librato if the queue is empty', ->
      librato.flush()
      expect(Client::send.calledOnce).to.be true

    it 'call callback immediately when queue is empty', (done) ->
      librato.flush (err) ->
        expect(Client::send.callCount).to.be 1
        done(err)

    it 'accepts a callback', (done) ->
      librato.increment('messages')
      librato.flush (err) ->
        expect(Client::send.callCount).to.be 2
        done(err)

  describe '::configuring', ->

    {clock} = {}
    beforeEach ->
      clock = sinon.useFakeTimers(new Date().getTime())

    it 'sends data every 60 seconds', ->
      sinon.stub(librato, 'flush')
      librato.configure email: 'foo@example.com', token: 'foobar'
      librato.start()
      expect(librato.flush.calledOnce).to.be false
      clock.tick(59000)
      expect(librato.flush.calledOnce).to.be false
      clock.tick(1100)
      expect(librato.flush.calledOnce).to.be true

    it 'allows you to configure the period', ->
      sinon.stub(librato, 'flush')
      librato.configure email: 'foo@example.com', token: 'foobar', period: 3000
      librato.start()
      clock.tick(4000)
      expect(librato.flush.calledOnce).to.be true

    afterEach ->
      clock.restore()
