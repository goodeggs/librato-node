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
      obj = name: name

      if values.length > 1
        values.sort()
        obj.count = values.length
        obj.sum = sum values
        obj.max = max values
        obj.min = min values
        obj.sum_squares = sum values.map (value) -> Math.pow(value, 2)
      else
        obj.value = values[0]

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
