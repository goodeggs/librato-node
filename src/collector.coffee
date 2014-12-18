CounterCache = require './counter_cache'
Aggregator = require './aggregator'
Annotation = require './annotation'

class Collector

  constructor: ->
    @counters = new CounterCache()
    @aggregate = new Aggregator()
    @annotation = new Annotation()

  increment: (args...) ->
    @counters.increment(args...)

  timing: (args...) ->
    @aggregate.timing(args...)

  annotate: (args...) ->
    @annotation.annotation(args...)

  flushTo: (queue) ->
    @counters.flushTo(queue)
    @aggregate.flushTo(queue)

  flushToAnnotation: (queue) ->
    @annotation.flushTo(queue)

module.exports = Collector

