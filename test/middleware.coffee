require './support/test_helper'
_ = require 'lodash'
middlewareFactoryFactory = require '../lib/middleware'
librato = require '..'

describe 'middleware', ->
  {middleware, fakeReq, fakeRes, stubLibrato} = {}
  
  beforeEach ->
    sinon.stub(librato)
    fakeReq = {headers: {}}
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
          
    describe 'X-Request-Start header', ->
      {clock} = {}
      
      beforeEach (done) ->
        clock = sinon.useFakeTimers(new Date().getTime())
        
        fakeReq.headers =
          'x-request-start': new Date().getTime() - 100
          'x-heroku-queue-depth': '2'
          'x-heroku-dynos-in-use': '4'
          'x-heroku-wait-time': '200'
          
        middleware fakeReq, fakeRes, ->
          fakeRes.end()
          done()

      afterEach ->
        clock.restore()
        
      it 'measures wait time', ->
        expect(librato.measure.calledWith('requestWaitTime', 100)).to.be true

    describe 'heroku headers', ->
      beforeEach (done) ->
        fakeReq.headers =
          'x-heroku-dynos-in-use': '4'
          'x-heroku-queue-depth': '2'
          'x-heroku-queue-wait-time': '200'
          
        middleware fakeReq, fakeRes, ->
          fakeRes.end()
          done()
        
      it 'measures queue depth', ->
        expect(librato.measure.calledWith('heroku.queueDepth', 2)).to.be true
        
      it 'measures queue wait time', ->
        expect(librato.measure.calledWith('heroku.queueWaitTime', 200)).to.be true

      it 'measures dyno count', ->
        expect(librato.measure.calledWith('heroku.dynos', 4)).to.be true
        
