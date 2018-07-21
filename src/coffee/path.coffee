{merge}  = require './helpers.coffee'

# ============================================================

exports.Path = class Path

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




# ============================================================

exports.PathBar = class PathBar extends Path

  constructor: (data) ->
    c = transform data
    super "M #{c.x0} #{c.h/2} " +
          "L #{c.x1} #{c.h/2}"

  view: (data, attributes) ->
    data.draw.path( merge attributes,
        "stroke-width":       data.barwidth
        fill:                 "none"
        d:                    @shape
      )

  transform: (data) ->
    transform data

  transform = (data) ->
    x0 = data.w * .1
    x1 = data.w * .9
    x = x0 + (x1 - x0) * data.rl

    merge data, { x: x, x0: x0, x1: x1}

# ============================================================
