{merge}  = require './helpers.coffee'

# ============================================================

class Path

  constructor: (@shape) ->

  shape: ->
    @shape

  init: (e, data) ->
    @length = e.getTotalLength()
    e.setAttribute "stroke-dasharray", @length
    @initialized = true

  update: (e, data) ->
    if (typeof @initialized == 'undefined')
      @init e, data

    e.setAttribute "stroke-dashoffset", @length * (1.0 - data.rl)

  setup_ticks: (e, data) ->
    @length = e.getTotalLength()
    a = data.tickThickness
    n = data.tickDivisions
    b = (@length-a*(n+1))/n
    e.setAttribute "stroke-dasharray", "#{a} #{b}"


# ============================================================

exports.PathH = class PathH extends Path

  constructor: (data) ->
    c = transform data
    super "M #{c.x0} #{c.h/2} " +
          "L #{c.x1} #{c.h/2}"

  # view: (data, attributes) ->
  #   data.draw.path( merge attributes,
  #       "stroke-width":       data.barWidth
  #       fill:                 "none"
  #       d:                    @shape
  #     )
  #
  # view_ticks: (data, attributes) ->
  #   data.draw.path( merge attributes,
  #       "stroke-width":       data.tickWidth
  #       fill:                 "none"
  #       d:                    @shape
  #     )

  transform: (data) ->
    transform data

  transform = (data) ->
    x0 = data.w * .1
    x1 = data.w * .9
    x = x0 + (x1 - x0) * data.rl

    merge data, { x: x, x0: x0, x1: x1}

# ============================================================
