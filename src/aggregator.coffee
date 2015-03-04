
sum = (values) -> values.reduce (a, b) -> a + b
max = (values) -> values.reduce (a, b) -> Math.max(a, b)
min = (values) -> values.reduce (a, b) -> Math.min(a, b)


class Aggregator
  constructor: ->
    @cache = {}
    
  flushTo: (queue) ->
    for name, values of @cache
      if (values.length > 1)
        values.sort()
        queue.push
          name: name
          count: values.length
          sum: sum values
          max: max values
          min: min values
          sum_squares: sum values.map (value) -> Math.pow(value, 2)
      else
        queue.push
          name: name
          value: values[0]
          
      delete @cache[name]
    
  timing: (name, value) ->
    (@cache[name] ?= []).push value

    
module.exports = Aggregator
