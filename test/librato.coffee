require './support/test_helper'
_ = require 'lodash'
libratoMetrics = require 'librato-metrics'
librato = require '..'

describe 'librato', ->
  beforeEach ->
    librato.configure email: 'foo@example.com', token: 'foobar'
    sinon.stub(libratoMetrics::, 'post').callsArg(2)
    
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
      
    it 'posts data to Librato', ->
      expect(libratoMetrics::post.calledOnce).to.be true
      args = libratoMetrics::post.getCall(0).args
      expect(args[0]).to.be '/metrics'
      names = _(args[1].gauges).pluck('name').value()
      expect(names).to.contain 'foo'
      expect(names).to.contain 'bar.count'

    it 'does not post data to Librato if the queue is empty', ->
      librato.flush()
      expect(libratoMetrics::post.calledOnce).to.be true

