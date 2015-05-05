require './support/test_helper'
_ = require 'lodash'
Aggregator = require '../lib/aggregator'

describe 'Aggregator', ->
  {aggregator} = {}

  beforeEach ->
    aggregator = new Aggregator()

  describe '::timing', ->
    it 'requires a function', ->
      expect(-> aggregator.timing('foobar')).to.throw

    describe 'given a synchronous function (arity 0)', ->
      {fn, retval} = {}

      beforeEach ->
        fn = @sinon.spy(-> 'foo')
        @sinon.stub(process, 'hrtime').returns([1, 1000000])
        retval = aggregator.timing 'foobar', fn

      afterEach ->
        process.hrtime.restore()

      it 'calls the function', ->
        expect(fn).to.have.been.calledOnce

      it "returns the function's return value", ->
        expect(retval).to.equal 'foo'

      it 'measures the duration', ->
        queue = []
        aggregator.flushTo(queue)
        expect(queue).to.have.length 1
        expect(queue[0]).to.have.property 'name', 'foobar'
        expect(queue[0]).to.have.property 'value', 1001
        expect(queue[0]).not.to.have.property 'source'

    describe 'given a synchronous function (arity 0) and a custom source', ->
      {fn, retval} = {}

      beforeEach ->
        fn = @sinon.spy(-> 'foo')
        @sinon.stub(process, 'hrtime').returns([1, 1000000])
        retval = aggregator.timing 'foobar;source1', fn

      afterEach ->
        process.hrtime.restore()

      it 'measures the duration', ->
        queue = []
        aggregator.flushTo(queue)
        expect(queue).to.have.length 1
        expect(queue[0]).to.have.property 'name', 'foobar'
        expect(queue[0]).to.have.property 'value', 1001
        expect(queue[0]).to.have.property 'source', 'source1'

    describe 'given an asynchronous function (arity 1)', ->
      {fn, retval} = {}

      beforeEach (done) ->
        fn = @sinon.spy((cb) -> process.nextTick(-> cb(null, 'foo')))
        @sinon.stub(process, 'hrtime').returns([1, 1000000])
        aggregator.timing 'foobar', fn, (err, _retval) ->
          retval = _retval
          done()

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
        expect(queue[0].value).to.equal 1001

  describe '::measure', ->

    it 'requires a value', ->
      expect(-> aggregator.measure('foobar')).to.throw

    it 'given a value, does not throw', ->
      expect(-> aggregator.measure('foobar', 1)).not.to.throw

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

    it 'handles metrics with a source', ->
      aggregator.measure('foobar;source', 100)
      queue = []
      aggregator.flushTo(queue)
      expect(queue).to.have.length 1

      foobar = queue[0]
      expect(foobar.source).to.equal 'source'

    it 'handles multiple metrics', ->
      aggregator.measure('foo', 100)
      aggregator.measure('bar', 200)
      queue = []
      aggregator.flushTo(queue)
      expect(queue).to.have.length 2

      foo = _(queue).find (item) -> item.name is 'foo'
      expect(foo.value).to.equal 100

      bar = _(queue).find (item) -> item.name is 'bar'
      expect(bar.value).to.equal 200

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
