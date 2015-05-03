CounterCache = require './counter_cache'
Aggregator = require './aggregator'

class Collector

  constructor: ->
    @counters = new CounterCache()
    @aggregate = new Aggregator()

  increment: (args...) ->
    @counters.increment(args...)

  measure: (args...) ->
    @aggregate.measure(args...)

  timing: (args...) ->
    @aggregate.timing(args...)

  flushTo: (gauges, counters) ->
    @aggregate.flushTo(gauges)
    @counters.flushTo(counters, counters != gauges)

module.exports = Collector

