require './support/test_helper'
_ = require 'lodash'
Aggregator = require '../lib/aggregator'

describe 'Aggregator', ->
  {aggregator} = {}

  beforeEach ->
    aggregator = new Aggregator()

  describe '::timing', ->
    it 'requires a function', ->
      expect(-> aggregator.timing('foobar')).to.throwError()

    describe 'given a synchronous function (arity 0)', ->
      {fn, retval} = {}

      beforeEach ->
        fn = sinon.stub().returns 'foo'
        sinon.stub(process, 'hrtime').returns([1, 1000000])
        retval = aggregator.timing 'foobar', fn

      afterEach ->
        process.hrtime.restore()

      it 'calls the function', ->
        expect(fn.callCount).to.equal 1

      it "returns the function's return value", ->
        expect(retval).to.equal 'foo'

      it 'measures the duration', ->
        queue = []
        aggregator.flushTo(queue)
        expect(queue).to.have.length 1
        expect(queue[0].name).to.equal 'foobar'
        expect(queue[0].sum).to.equal 1001

  describe '::measure', ->

    it 'requires a value', ->
      expect(-> aggregator.measure('foobar')).to.throwError()

    it 'given a value, does not throw', ->
      expect(-> aggregator.measure('foobar', 1)).not.to.throwError()

    it 'handles a single metric', ->
      aggregator.measure('foobar', 100)
      aggregator.measure('foobar', 200)
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
      aggregator.measure('foo', 100)
      aggregator.measure('bar', 200)
      queue = []
      aggregator.flushTo(queue)
      expect(queue).to.have.length 2

      foo = _(queue).find (item) -> item.name is 'foo'
      expect(foo.count).to.equal 1
      expect(foo.min).to.equal 100
      expect(foo.max).to.equal 100
      expect(foo.sum).to.equal 100
      expect(foo.sum_squares).to.equal 10000

      bar = _(queue).find (item) -> item.name is 'bar'
      expect(bar.count).to.equal 1
      expect(bar.min).to.equal 200
      expect(bar.max).to.equal 200
      expect(bar.sum).to.equal 200
      expect(bar.sum_squares).to.equal 40000

    describe '::flushTo', ->
      it 'clears the internal queue', ->
        aggregator.measure('foo', 100)
        aggregator.measure('bar', 200)
        queue = []
        aggregator.flushTo queue
        expect(queue).to.have.length 2

        queue = []
        aggregator.flushTo queue
        expect(queue).to.have.length 0

