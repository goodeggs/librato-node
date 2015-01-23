{EventEmitter} = require 'events'
Client = require './client'
Worker = require './worker'
Collector = require './collector'
middleware = require './middleware'

{collector, client, worker, config} = {}

librato = new EventEmitter()

librato.configure = (newConfig) ->
  config = newConfig
  collector = new Collector()
  client = new Client config
  worker = new Worker job: librato.flush

librato.increment = (name, value = 1) ->
  name = sanitize_name(name)
  collector.increment "#{config.prefix ? ''}#{name}", value

librato.timing = (name, valueMs) ->
  name = sanitize_name(name)
  collector.timing "#{config.prefix ? ''}#{name}", valueMs

librato.measure = librato.timing # alias
    
librato.start = ->
  worker.start()
    
librato.stop = ->
  worker.stop()
  librato.flush()
    
librato.flush = ->
  gauges = []
  collector.flushTo gauges
  measurement.source = config.source for measurement in gauges
  if gauges.length
    client.send {gauges}, (err) ->
      librato.emit 'error', err if err?

librato.middleware = middleware(librato)


module.exports = librato

# from the official librato statsd backend
# https://github.com/librato/statsd-librato-backend/blob/dffece631fcdc4c94b2bff1f7526486aa5bfbab9/lib/librato.js#L144
sanitize_name = (name) ->
  return name.replace(/[^-.:_\w]+/g, '_').substr(0,255)

