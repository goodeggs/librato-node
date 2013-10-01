d3 = require 'd3'

class Aggregator
  constructor: ->
    @cache = {}
    
  flushTo: (queue) ->
    for name, values of @cache
      values.sort()
      queue.push
        name: name
        count: values.length
        sum: d3.sum values
        max: d3.max values
        min: d3.min values
        sum_squares: d3.sum values, (value) -> Math.pow(value, 2)
      delete @cache[name]
    
  timing: (name, value) ->
    (@cache[name] ?= []).push value

    
module.exports = Aggregator
