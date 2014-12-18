require './support/test_helper'
_ = require 'lodash'
Annotation = require '../lib/annotation'

describe 'Annotation', ->
  {annotation} = {}

  beforeEach ->
    annotation = new Annotation()

  describe '::annotation', ->
    it 'adds a single annotation', ->
      annotation.annotation('foo', 'bar')
      queue = []
      annotation.flushTo(queue)
      expect(queue).to.have.length 1
      expect(queue[0]).to.eql {name: 'foo', value: [{title: 'bar'}]}

    it 'adds multiple annotations', ->
      annotation.annotation('foo', 'bar')
      annotation.annotation('foo2', 'bar2')
      queue = []
      annotation.flushTo(queue)
      expect(queue).to.have.length 2
      expect(queue[0]).to.eql {name: 'foo', value: [{title: 'bar'}]}
      expect(queue[1]).to.eql {name: 'foo2', value: [{title: 'bar2'}]}

  describe '::flushTo', ->
    it 'clears the internal queue', ->
      annotation.annotation('foo', 'bar')
      queue = []
      annotation.flushTo queue
      expect(queue).to.have.length 1
      
      queue = []
      annotation.flushTo queue
      expect(queue).to.have.length 0

