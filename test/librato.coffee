require './support/test_helper'
_ = require 'lodash'
Client = require '../lib/client'
librato = require '..'

describe 'librato', ->
  beforeEach ->
    librato.configure email: 'foo@example.com', token: 'foobar'
    @sinon.stub(Client::, 'send').callsArg(1)

  describe '::increment', ->

    it 'defaults increment to 1', ->
      librato.increment('messages')
      librato.flush()
      expect(Client::send.calledOnce).to.be.true
      args = Client::send.getCall(0).args
      names = _(args[0].counters).pluck('name').value()
      values = _(args[0].counters).pluck('value').value()
      expect(names).to.contain 'messages'
      expect(values).to.contain 1

    it 'can increment more than 1', ->
      librato.increment('messages', 2)
      librato.flush()
      expect(Client::send.calledOnce).to.be.true
      args = Client::send.getCall(0).args
      names = _(args[0].counters).pluck('name').value()
      values = _(args[0].counters).pluck('value').value()
      expect(names).to.contain 'messages'
      expect(values).to.contain 2

    it 'translates unsupported metric characters to underscores', ->
      librato.increment('this/is/:a/(test?!)')
      librato.flush()
      expect(Client::send.calledOnce).to.be.true
      args = Client::send.getCall(0).args
      names = _(args[0].counters).pluck('name').value()
      values = _(args[0].counters).pluck('value').value()
      expect(names).to.contain 'this_is_:a_test_'

    it 'accepts a custom source', ->
      librato.increment('messages', {source: 'source1'})
      librato.increment('messages', {source: 'source2'})
      librato.flush()
      expect(Client::send.calledOnce).to.be.true
      args = Client::send.getCall(0).args
      names = _(args[0].counters).pluck('name').value()
      sources = _(args[0].counters).pluck('source').value()
      values = _(args[0].counters).pluck('value').value()
      expect(names).to.eql ['messages', 'messages']
      expect(values).to.eql [1, 1]
      expect(sources).to.eql ['source1', 'source2']

  describe '::timing', ->
    describe 'with a synchronous function', ->
      it 'does not throw', ->
        expect(-> librato.timing('foobar', (->))).not.to.throw

      describe 'with a custom source', ->
        it 'does not throw', ->
          expect(-> librato.timing('foobar', ((cb) ->), source: 'bar')).not.to.throw

    describe 'with an asynchronous function', ->
      it 'does not throw', ->
        expect(-> librato.timing('foobar', ((cb) ->))).not.to.throw

  describe '::measure', ->
    it 'does not throw', ->
      expect(-> librato.measure('foobar', 1)).not.to.throw

    it 'translates unsupported metric characters to underscores', ->
      librato.measure('this/is/:a/(test?!)2', 1)
      librato.flush()
      expect(Client::send.calledOnce).to.be.true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      expect(names).to.contain 'this_is_:a_test_2'

  describe '::flush', ->
    beforeEach ->
      librato.increment('foo')
      librato.measure('bar', 1)
      librato.flush()

    it 'sends data to Librato', ->
      expect(Client::send.calledOnce).to.be.true
      args = Client::send.getCall(0).args
      names = _(args[0].counters).pluck('name').value()
      expect(names).to.contain 'foo'
      names = _(args[0].gauges).pluck('name').value()
      expect(names).to.contain 'bar'

    it 'does not post data to Librato if the queue is empty', ->
      Client::send.reset()
      librato.flush()
      expect(Client::send).not.to.have.been.called

    it 'call callback immediately when queue is empty', (done) ->
      Client::send.reset()
      librato.flush (err) ->
        expect(Client::send).not.to.have.been.called
        done(err)

    it 'accepts a callback', (done) ->
      librato.increment('messages')
      librato.flush (err) ->
        expect(Client::send).to.have.been.calledTwice
        done(err)

  describe '::configuring', ->

    {clock} = {}
    beforeEach ->
      clock = @sinon.useFakeTimers(new Date().getTime())

    it 'sends data every 60 seconds', ->
      @sinon.stub(librato, 'flush')
      librato.configure email: 'foo@example.com', token: 'foobar'
      librato.start()
      expect(librato.flush.calledOnce).to.be.false
      clock.tick(59000)
      expect(librato.flush.calledOnce).to.be.false
      clock.tick(1100)
      expect(librato.flush.calledOnce).to.be.true

    it 'allows you to configure the period', ->
      @sinon.stub(librato, 'flush')
      librato.configure email: 'foo@example.com', token: 'foobar', period: 3000
      librato.start()
      clock.tick(4000)
      expect(librato.flush.calledOnce).to.be.true

    afterEach ->
      clock.restore()
