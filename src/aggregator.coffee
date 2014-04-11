d3 = require 'd3'

class Aggregator
  constructor: ->
    @cache = {}
    
  flushTo: (queue) ->
    for metric, values of @cache
      [name, source] = metric.split(';')
      values.sort()
      obj =
        name: name
        count: values.length
        sum: d3.sum values
        max: d3.max values
        min: d3.min values
        sum_squares: d3.sum values, (value) -> Math.pow(value, 2)
      obj.source = source if source?
      queue.push obj
      delete @cache[metric]
    
  timing: (name, value) ->
    (@cache[name] ?= []).push value

    
module.exports = Aggregator
