require './support/test_helper'
_ = require 'lodash'
Client = require '../lib/client'
librato = require '..'

describe 'librato', ->
  beforeEach ->
    librato.configure email: 'foo@example.com', token: 'foobar'
    sinon.stub(Client::, 'send').callsArg(1)

    
  describe '::increment', ->
    it 'does not throw an error', ->
      librato.increment('foobar')

    it 'translates unsupported metric characters to underscores', ->
      librato.increment('this/is/:a/(test?!)')
      librato.flush()
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      expect(names).to.contain 'this_is_:a_test_'
    
  describe '::timing', ->
    it 'does not throw an error', ->
      librato.timing('foobar')

    it 'translates unsupported metric characters to underscores', ->
      librato.timing('this/is/:a/(test?!)2')
      librato.flush()
      expect(Client::send.calledOnce).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      expect(names).to.contain 'this_is_:a_test_2'
    
  describe '::annotation', ->
    it 'does not throw an error', ->
      librato.annotation('foobar')
    
  describe '::flush', ->
    beforeEach ->
      librato.increment('foo')
      librato.timing('bar')
      librato.annotation('foo', 'bar')
      librato.flush()
      
    it 'sends data to Librato', ->
      expect(Client::send.calledTwice).to.be true
      args = Client::send.getCall(0).args
      names = _(args[0].gauges).pluck('name').value()
      args2 = Client::send.getCall(1).args
      annotation = _(args2[0].annotation).value()
      expect(names).to.contain 'foo'
      expect(names).to.contain 'bar'
      expect(annotation).to.be true


    it 'does not post data to Librato if the queue is empty', ->
      librato.flush()
      expect(Client::send.calledTwice).to.be true

    it 'sends two annotations to Librato', ->
      librato.annotation('foo', 'an1')
      librato.annotation('foo', 'an2')
      librato.flush()
      expect(Client::send.callCount).to.equal 4

