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
      # queue.push
      obj =
        name: name
        count: values.length
        sum: sum values
        max: max values
        min: min values
        sum_squares: sum values.map (value) -> Math.pow(value, 2)
      obj.source = source  if source?
      queue.push obj
      delete @cache[key]

  timing: (name, value) ->
    (@cache[name] ?= []).push value


module.exports = Aggregator
