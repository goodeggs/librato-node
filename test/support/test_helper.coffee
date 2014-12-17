require('source-map-support').install()

realSinon = require 'sinon'
replay = require 'replay'
replay.fixtures = "#{__dirname}/../fixtures"
expect = require 'expect.js'

GLOBAL.sinon = null
GLOBAL.expect = expect

beforeEach ->
  GLOBAL.sinon = realSinon.sandbox.create()
  
afterEach ->
  GLOBAL.sinon.restore()

