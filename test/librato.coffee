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
    
  describe '::timing', ->
    it 'does not throw an error', ->
      librato.timing('foobar')
    
  describe '::flush', ->
    beforeEach ->
      librato.increment('foo')
      librato.timing('bar')
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

