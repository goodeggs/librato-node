{EventEmitter} = require 'events'
libratoMetrics = require 'librato-metrics'
Worker = require './worker'
Collector = require './collector'
middleware = require './middleware'

{collector, client, worker, config} = {}

librato = new EventEmitter()

librato.configure = (newConfig) ->
  config = newConfig
  collector = new Collector()
  client = libratoMetrics.createClient config
  worker = new Worker job: librato.flush
  
librato.increment = (name) ->
  collector.increment(name)

librato.timing = (name, valueMs) ->
  collector.timing(name, valueMs)
    
librato.start = ->
  worker.start()
    
librato.stop = ->
  worker.stop()
  librato.flush()
    
librato.flush = ->
  queue = []
  collector.flushTo queue
  if queue.length
    data =
      gauges: queue
      source: config.source
    client.post '/metrics', data, (err) ->
      librato.emit 'error', err if err?

librato.middleware = middleware(librato)


module.exports = librato

