
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
    earliest = new Date(Date.now() + period)
    # already on a whole minute
    return earliest.valueOf() if earliest.getSeconds() is 0
    if period > 30
      # bump to whole minute
      return earliest.valueOf() + (60 - earliest.getSeconds())
    else
      # ensure sync to whole minute if minute is evenly divisible
      return earliest.valueOf() + (period - (earliest.getSeconds() % period))


module.exports = Worker

