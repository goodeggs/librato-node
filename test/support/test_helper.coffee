require('source-map-support').install()
require 'mocha-sinon'
{expect} = chai = require 'chai'
chai.use require('sinon-chai')

global.expect = expect
