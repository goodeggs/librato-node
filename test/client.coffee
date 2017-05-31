require './support/test_helper'
Client = require '../lib/client'
nock = require 'nock'

describe 'Client', ->
  {client} = {}

  describe 'with email and token', ->

    beforeEach ->
      nock('https://metrics-api.librato.com/v1')
        .post('/metrics')
        .basicAuth(user: 'foo@example.com', pass: 'bob')
        .delay(10)
        .reply(200)
      client = new Client email: 'foo@example.com', token: 'bob'

    afterEach ->
      nock.cleanAll()

    describe '::send', ->
      it 'sends data to Librato', (done) ->
        client.send {gauges: [{name: 'foo', value: 1}]}, done

  describe 'Librato returns a 400', ->

    beforeEach ->
      nock('https://metrics-api.librato.com/v1')
        .post('/metrics')
        .basicAuth(user: 'foo@example.com', pass: 'bob')
        .reply(400, errors: {params: {name: ['is not present']}})
      client = new Client email: 'foo@example.com', token: 'bob'

    afterEach ->
      nock.cleanAll()

    describe '::send', ->
      it 'throws an error with the response body', (done) ->
        client.send {gauges: [{name: '', value: 1}]}, (err) ->
          expect(err.message).to.equal "Error sending to Librato: { errors: { params: { name: [ 'is not present' ] } } } (statusCode: 400)"
          done()

  describe 'with timeout via requestOptions', ->

    beforeEach ->
      nock('https://metrics-api.librato.com/v1')
        .post('/metrics')
        .basicAuth(user: 'foo@example.com', pass: 'bob')
        .socketDelay(10)
        .reply(200)
      client = new Client email: 'foo@example.com', token: 'bob', requestOptions: {timeout: 5}

    afterEach ->
      nock.cleanAll()

    describe '::send', ->
      it 'throws timeout error', (done) ->
        client.send {gauges: [{name: 'foo', value: 1}]}, (err) ->
          expect(err.code).to.equal 'ESOCKETTIMEDOUT'
          done()

  describe 'in simulate mode', ->

    beforeEach ->
      client = new Client simulate: true

    describe '::send', ->
      it 'sends data to Librato', (done) ->
        client.send {gauges: [{name: 'foo', value: 1}]}, done

