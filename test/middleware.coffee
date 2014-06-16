require './support/test_helper'
_ = require 'lodash'
middlewareFactoryFactory = require '../src/middleware'
librato = require '../src/librato'

describe 'middleware', ->
  {middleware, fakeReq, fakeRes, stubLibrato} = {}

  beforeEach ->
    sinon.stub(librato)
    fakeReq = {}
    fakeRes = {end: (->), statusCode: 200}

  describe 'with defaults', ->
    beforeEach ->
      middleware = middlewareFactoryFactory(librato)()

    describe 'request count', ->
      it 'increments for each request', (done) ->
        middleware fakeReq, fakeRes, ->
          expect(librato.increment.calledWith('requestCount')).to.be true
          done()

    describe 'response time', ->
      {clock} = {}
      beforeEach ->
        clock = sinon.useFakeTimers(new Date().getTime())

      afterEach ->
        clock.restore()

      it 'measures for each request', (done) ->
        middleware fakeReq, fakeRes, ->
          expect(librato.timing.calledWith('responseTime')).to.be false
          clock.tick(101)
          fakeRes.end()
          expect(librato.timing.calledWith('responseTime', 101)).to.be true
          done()

    describe 'status code', ->
      it 'increments for each request', (done) ->
        middleware fakeReq, fakeRes, ->
          expect(librato.increment.calledWith('statusCode.2xx')).to.be false
          fakeRes.end()
          expect(librato.increment.calledWith('statusCode.2xx')).to.be true
          done()
