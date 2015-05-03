require './support/test_helper'
_ = require 'lodash'
CounterCache = require '../lib/counter_cache'

describe 'CounterCache', ->
  {counter} = {}

  beforeEach ->
    counter = new CounterCache()

  describe '::increment', ->
    it 'counts a single metric', ->
      counter.increment('foobar')
      counter.increment('foobar')
      queue = []
      counter.flushTo(queue)
      expect(queue).to.have.length 1
      expect(queue[0]).to.eql {name: 'foobar', value: 2}

    it 'counts metrics with a source', ->
      counter.increment('foobar;source')
      counter.increment('foobar;source')
      queue = []
      counter.flushTo(queue)
      expect(queue).to.have.length 1
      expect(queue[0]).to.eql {name: 'foobar', value: 2, source: 'source'}

    it 'counts multiple metrics', ->
      counter.increment('foo')
      counter.increment('bar')
      queue = []
      counter.flushTo queue
      expect(queue).to.have.length 2
      foo = _(queue).find (item) -> item.name is 'foo'
      expect(foo.value).to.equal 1
      bar = _(queue).find (item) -> item.name is 'bar'
      expect(bar.value).to.equal 1

  describe '::flushTo', ->
    it 'clears the internal queue', ->
      counter.increment('foo')
      queue = []
      counter.flushTo queue, true
      expect(queue).to.have.length 1

      queue = []
      counter.flushTo queue, false
      expect(queue).to.have.length 1

      queue = []
      counter.flushTo queue, false
      expect(queue).to.have.length 0
