require './support/test_helper'
Client = require '../lib/client'

describe 'Client', ->
  {client} = {}

  describe 'with email and token', ->

    beforeEach ->
      client = new Client email: 'foo@example.com', token: 'bob'

    describe '::send', ->
      it 'sends data to Librato', (done) ->
        client.send {gauges: [{name: 'foo', value: 1}]}, done

  describe 'in simulate mode', ->

    beforeEach ->
      client = new Client simulate: true

    describe '::send', ->
      it 'sends data to Librato', (done) ->
        client.send {gauges: [{name: 'foo', value: 1}]}, done
