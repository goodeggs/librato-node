assert = require 'assert'

sum = (values) -> values.reduce (a, b) -> a + b
max = (values) -> values.reduce (a, b) -> Math.max(a, b)
min = (values) -> values.reduce (a, b) -> Math.min(a, b)


class Aggregator
  constructor: ->
    @cache = {}

  flushTo: (queue) ->
    for key, values of @cache
      [name, source] = key.split ';'
      values.sort()
      obj =
        name: name
        count: values.length
        sum: sum values
        max: max values
        min: min values
        sum_squares: sum values.map (value) -> Math.pow(value, 2)
      obj.source = source if source?
      queue.push obj
      delete @cache[key]
    
  measure: (key, value) ->
    assert value?, 'value is required'
    (@cache[key] ?= []).push value

  timing: (key, fn, cb) ->
    assert fn?, 'function is required'
    start = process.hrtime()
    done = =>
      [sec, usec] = process.hrtime(start)
      msec = (sec * 1000) + Math.max(usec / 1000 / 1000)
      (@cache[key] ?= []).push msec
    if fn.length
      fn (args...) ->
        done()
        cb?.apply @, args
    else
      retval = fn()
      done()
      return retval

module.exports = Aggregator
