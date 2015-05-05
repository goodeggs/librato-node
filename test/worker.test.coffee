require './support/test_helper'
Worker = require '../lib/worker'

given_period = (period) ->
  return {
    returns: (expected) ->
      it "given period #{period} returns #{expected}", ->
        expect(Worker.startTime(period)).to.equal expected
   }

describe 'Worker', ->

  describe '.startTime', ->
    {clock, period} = {}

    beforeEach ->
      clock = sinon.useFakeTimers(0)

    describe 'at 00:00:00', ->

      given_period(60000).returns(60000)
      given_period(30000).returns(30000)
      given_period(1000).returns(1000)

    describe 'at 00:00:01', ->
      beforeEach ->
        clock.tick 1000

      given_period(60000).returns(60000)
      given_period(30000).returns(30000)
      given_period(1000).returns(2000)

    describe 'at 00:00:30', ->
      beforeEach ->
        clock.tick 30000

      given_period(60000).returns(60000)
      given_period(30000).returns(60000)
      given_period(1000).returns(31000)

    describe 'at 00:01:00.100', ->
      beforeEach ->
        clock.tick 60100

      given_period(60000).returns(120000)
      given_period(30000).returns(90000)
      given_period(1000).returns(61000)

