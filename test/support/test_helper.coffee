realSinon = require 'sinon'
expect = require 'expect.js'

GLOBAL.sinon = null
GLOBAL.expect = expect

beforeEach ->
  GLOBAL.sinon = realSinon.sandbox.create()
  
afterEach ->
  GLOBAL.sinon.restore()

