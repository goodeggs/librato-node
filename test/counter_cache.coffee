require './support/test_helper'
_ = require 'lodash'
CounterCache = require '../lib/counter_cache'

describe 'CounterCache', ->
  {counter, queue} = {}

  beforeEach ->
    counter = new CounterCache()
    queue = []

  describe '::increment', ->
    it 'counts a single metric', ->
      counter.increment('foobar')
      counter.increment('foobar')
      counter.flushTo(queue)
      expect(queue).to.eql [{name: 'foobar', value: 2}]

    it 'counts metrics with a source', ->
      counter.increment('foobar;source')
      counter.increment('foobar;source')
      counter.flushTo(queue)
      expect(queue).to.eql [{name: 'foobar', value: 2, source: 'source'}]

    it 'counts multiple metrics', ->
      counter.increment('foo')
      counter.increment('bar')
      counter.flushTo queue
      expect(queue).to.eql [{name: 'foo', value: 1}, {name: 'bar', value: 1}]

  describe '::flushTo', ->

    it 'flushes an ever-increasing value', ->
      counter.increment('foo')
      counter.flushTo queue
      expect(queue).to.eql [{name: 'foo', value: 1}]

      counter.increment('foo')
      counter.flushTo queue
      expect(queue).to.eql [{name: 'foo', value: 1},{name: 'foo', value: 2}]

