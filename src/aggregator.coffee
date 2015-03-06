assert = require 'assert'

sum = (values) -> values.reduce (a, b) -> a + b
max = (values) -> values.reduce (a, b) -> Math.max(a, b)
min = (values) -> values.reduce (a, b) -> Math.min(a, b)


class Aggregator
  constructor: ->
    @cache = {}
    
  flushTo: (queue) ->
    for name, values of @cache
      values.sort()
      queue.push
        name: name
        count: values.length
        sum: sum values
        max: max values
        min: min values
        sum_squares: sum values.map (value) -> Math.pow(value, 2)
      delete @cache[name]
    
  measure: (name, value) ->
    assert value?, 'value is required'
    (@cache[name] ?= []).push value

  timing: (name, fn) ->
    assert fn?, 'function is required'
    start = process.hrtime()
    retval = fn()
    [sec, usec] = process.hrtime(start)
    msec = (sec * 1000) + Math.max(usec / 1000 / 1000)
    (@cache[name] ?= []).push msec
    return retval
    
module.exports = Aggregator
