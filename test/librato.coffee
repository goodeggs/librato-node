require './support/test_helper'
_ = require 'lodash'
Client = require '../lib/client'
Collector = require '../lib/collector'
librato = require '..'

describe 'librato', ->
  beforeEach ->
    librato.configure email: 'foo@example.com', token: 'foobar'

  describe '::increment', ->
    beforeEach ->
      @sinon.stub(Collector::, 'increment')

    it 'defaults increment to 1', ->
      librato.increment('messages')
      expect(Collector::increment).to.have.been.calledWith 'messages', 1

    it 'can increment more than 1', ->
      librato.increment('messages', 2)
      expect(Collector::increment).to.have.been.calledWith 'messages', 2

    it 'translates unsupported metric characters to underscores', ->
      librato.increment('this/is/:a/(test?!)')
      expect(Collector::increment).to.have.been.calledWith 'this_is_:a_test_', 1

    it 'accepts a custom source', ->
      librato.increment('messages', {source: 'source1'})
      expect(Collector::increment).to.have.been.calledWith 'messages;source1', 1

  describe '::timing', ->
    beforeEach ->
      @sinon.stub(Collector::, 'timing')

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
    beforeEach ->
      @sinon.stub(Collector::, 'measure')

    it 'does not throw', ->
      librato.measure('foobar', 1)
      expect(Collector::measure).to.have.been.calledWith 'foobar', 1

    it 'translates unsupported metric characters to underscores', ->
      librato.measure('this/is/:a/(test?!)2', 1)
      expect(Collector::measure).to.have.been.calledWith 'this_is_:a_test_2', 1

  describe '::flush', ->
    beforeEach ->
      @sinon.stub(Client::, 'send').yields()

    describe 'with a full queue', ->
      beforeEach ->
        @sinon.stub Collector::, 'flushTo', (gauges, counters) ->
          gauges.push {name: 'foo', value: 1}
          counters.push {name: 'bar', value: 1}

      it 'sends data to Librato', ->
        librato.flush()
        expect(Client::send).to.have.been.calledWithMatch
          counters: [{name: 'foo', value: 1}]
          gauges: [{name: 'bar', value: 1}]

      it 'accepts a callback', (done) ->
        cb = @sinon.spy()
        librato.flush cb
        process.nextTick ->
          expect(cb).to.have.been.called
          done()

    describe 'with an empty queue', ->
      beforeEach ->
        @sinon.stub(Collector::, 'flushTo')

      it 'does not post data and calls callback immediately', (done) ->
        librato.flush (err) ->
          expect(Client::send).not.to.have.been.called
          done(err)


  describe '::configuring', ->

    {clock} = {}
    beforeEach ->
      clock = @sinon.useFakeTimers(0)

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

