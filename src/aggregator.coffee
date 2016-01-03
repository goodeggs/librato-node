assert = require 'assert'


class Aggregator
  constructor: ->
    @cache = {}

  flushTo: (queue) ->
    for key, state of @cache
      [name, source] = key.split ';'

      if state.count > 1
        obj = state
      else
        obj = value: state.sum

      obj.name = name
      obj.source = source if source?
      queue.push obj

      delete @cache[key]

  measure: (key, value) ->
    assert value?, 'value is required'
    @cache[key] ?= {count: 0, sum: 0, min: value, max: value, sum_squares: 0}
    @cache[key].count++
    @cache[key].sum += value
    @cache[key].min = Math.min(@cache[key].min, value)
    @cache[key].max = Math.max(@cache[key].max, value)
    @cache[key].sum_squares += Math.pow(value, 2)

  timing: (key, fn, cb) ->
    assert fn?, 'function is required'
    start = process.hrtime()
    done = =>
      [sec, usec] = process.hrtime(start)
      msec = (sec * 1000) + Math.max(usec / 1000 / 1000)
      this.measure(key, msec)
    if fn.length
      fn (args...) ->
        done()
        cb?.apply @, args
    else
      retval = fn()
      done()
      return retval

module.exports = Aggregator
