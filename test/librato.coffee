require './support/test_helper'
_ = require 'lodash'
Client = require '../lib/client'
librato = require '..'

describe 'librato failure', ->
  beforeEach ->
    librato.configure email: 'foo@example.com', token: 'foobar'
    sinon.stub Client::, 'send', (data, cb) ->
      cb new Error 'error sending data: {} 500'

  it 'does not crash the client', (done) ->
    librato.increment('messages')
    librato.flush()


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

  describe '::timing', ->
    describe 'with a synchronous function', ->
      it 'does not throw', ->
        expect(-> librato.timing('foobar', (->))).not.to.throwError()

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
