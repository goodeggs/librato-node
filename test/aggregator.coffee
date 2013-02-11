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
      expect(queue).to.have.length 4
      
      count = _(queue).find (item) -> item.name is 'foobar.count'
      expect(count.value).to.equal 2

      min = _(queue).find (item) -> item.name is 'foobar.min'
      expect(min.value).to.equal 100
      
      max = _(queue).find (item) -> item.name is 'foobar.max'
      expect(max.value).to.equal 200

      mean_90 = _(queue).find (item) -> item.name is 'foobar.mean_90'
      expect(mean_90.value).to.equal 190
      
    it 'handles multiple metrics', ->
      aggregator.timing('foo', 100)
      aggregator.timing('bar', 200)
      queue = []
      aggregator.flushTo(queue)
      expect(queue).to.have.length 8

      fooCount = _(queue).find (item) -> item.name is 'foo.count'
      expect(fooCount.value).to.equal 1

      fooMean90 = _(queue).find (item) -> item.name is 'foo.mean_90'
      expect(fooMean90.value).to.equal 100

      barCount = _(queue).find (item) -> item.name is 'bar.count'
      expect(barCount.value).to.equal 1

      barMean90 = _(queue).find (item) -> item.name is 'bar.mean_90'
      expect(barMean90.value).to.equal 200
      

    describe '::flushTo', ->
      it 'clears the internal queue', ->
        aggregator.timing('foo', 100)
        queue = []
        aggregator.flushTo queue
        expect(queue).to.have.length 4
        
        queue = []
        aggregator.flushTo queue
        expect(queue).to.have.length 0

