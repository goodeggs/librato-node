require './support/test_helper'
_ = require 'lodash'
Aggregator = require '../lib/aggregator'

describe 'Aggregator', ->
  {aggregator} = {}

  beforeEach ->
    aggregator = new Aggregator()

  describe '::timing', ->
    it 'handles a single metric', ->
      aggregator.timing('foobar', 100)
      aggregator.timing('foobar', 200)
      queue = []
      aggregator.flushTo(queue)
      expect(queue).to.have.length 1

      foobar = queue[0]
      expect(foobar.count).to.equal 2
      expect(foobar.min).to.equal 100
      expect(foobar.max).to.equal 200
      expect(foobar.sum).to.equal 300
      expect(foobar.sum_squares).to.equal 50000

    it 'handles multiple metrics', ->
      aggregator.timing('foo', 100)
      aggregator.timing('bar', 200)
      queue = []
      aggregator.flushTo(queue)
      expect(queue).to.have.length 2

      foo = _(queue).find (item) -> item.name is 'foo'
      expect(foo.value).to.equal 100

      bar = _(queue).find (item) -> item.name is 'bar'
      expect(bar.value).to.equal 200

    describe '::flushTo', ->
      it 'clears the internal queue', ->
        aggregator.timing('foo', 100)
        aggregator.timing('bar', 200)
        queue = []
        aggregator.flushTo queue
        expect(queue).to.have.length 2

        queue = []
        aggregator.flushTo queue
        expect(queue).to.have.length 0

