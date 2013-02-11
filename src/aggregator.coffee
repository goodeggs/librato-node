d3 = require 'd3'

class Aggregator
  constructor: ->
    @cache = {}
    
  flushTo: (queue) ->
    for name, values of @cache
      values.sort()
      queue.push {name: "#{name}.count", value: values.length}
      queue.push {name: "#{name}.min",   value: d3.min(values)}
      queue.push {name: "#{name}.max",   value: d3.max(values)}
      queue.push {name: "#{name}.mean_90", value: d3.quantile(values, 0.9)}
      delete @cache[name]
    
  timing: (name, value) ->
    (@cache[name] ?= []).push value

    
module.exports = Aggregator

