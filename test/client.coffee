require './support/test_helper'
Client = require '../src/client'

describe 'Client', ->
  {client} = {}
  
  beforeEach ->
    client = new Client email: 'foo@example.com', token: 'bob'
    
  describe '::send', ->
    it 'sends data to Librato', (done) ->
      client.send {gauges: [{name: 'foo', value: 1}]}, done

