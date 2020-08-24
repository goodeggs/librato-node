require './support/test_helper'
Worker = require '../lib/worker'

givenPeriod = (period) ->
  return {
    returns: (expected) ->
      it "given period #{period} returns #{expected}", ->
        expect(Worker.startTime(period)).to.equal expected
   }

describe 'Worker', ->
  describe 'constructor', ->
    it 'sets `@period` to given `period` if defined', ->
      expect(
        new Worker({period: 15000, job: @sinon.stub()})
      ).to.have.property('period', 15000)

    it 'sets `@period` to default of 60000 if none given', ->
      expect(
        new Worker({job: @sinon.stub()})
      ).to.have.property('period', 60000)

  describe '.start', ->
    {clock} = {}

    beforeEach ->
      clock = @sinon.useFakeTimers(0)

    it 'calls given `job` once first given `period` has passed', ->
      job = @sinon.stub()
      worker = new Worker({job, period: 15000})

      worker.start()
      expect(job).not.to.have.been.called
      clock.tick(14999)
      expect(job).not.to.have.been.called
      clock.tick(2)
      expect(job).to.have.been.calledOnce

    it 'calls given `job` a second time one `period` after the first call', ->
      job = @sinon.stub()
      worker = new Worker({job, period: 15000})

      worker.start()
      clock.tick(15006)
      job.reset()

      clock.tick(15000)
      expect(job).to.have.been.calledOnce

    it 'sleeps until start of the next period if less than a period has elapsed since last call to `job`', ->
      job = @sinon.stub()
      worker = new Worker({job, period: 15000})

      worker.start()
      clock.tick(45000)
      job.reset()

      clock.tick(14900)
      expect(job).not.to.have.been.called
      expect(clock.countTimers()).to.equal(1)

  describe '.startTime', ->
    {clock, period} = {}

    beforeEach ->
      clock = @sinon.useFakeTimers(0)

    describe 'at 00:00:00', ->
      givenPeriod(60000).returns(60000)
      givenPeriod(30000).returns(30000)
      givenPeriod(1000).returns(1000)

    describe 'at 00:00:01', ->
      beforeEach ->
        clock.tick 1000

      givenPeriod(60000).returns(60000)
      givenPeriod(30000).returns(30000)
      givenPeriod(1000).returns(2000)

    describe 'at 00:00:30', ->
      beforeEach ->
        clock.tick 30000

      givenPeriod(60000).returns(60000)
      givenPeriod(30000).returns(60000)
      givenPeriod(1000).returns(31000)

    describe 'at 00:01:00.100', ->
      beforeEach ->
        clock.tick 60100

      givenPeriod(60000).returns(120000)
      givenPeriod(30000).returns(90000)
      givenPeriod(1000).returns(61000)
