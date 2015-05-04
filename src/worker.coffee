
class Worker

  period: 60000

  constructor: ({@job, period}={}) ->
    throw new Error('must provide job') unless @job?
    @period = period if period?
    @stopped = true

  start: ->
    @stopped = false
    nextRun = Worker.startTime(@period)
    workFn = =>
      loop
        now = Date.now()
        if now >= nextRun
          @job()
          nextRun += @period while nextRun <= now
        else
          return (@timerId = setTimeout workFn, (nextRun - now))
    workFn()

  stop: ->
    return if @stopped
    @stopped = true
    clearTimeout @timerId if @timerId?

  # Give some structure to worker start times so when possible they will be in sync.
  @startTime: (period) ->
    now = Date.now()
    return now + (period - (now % period))


module.exports = Worker
