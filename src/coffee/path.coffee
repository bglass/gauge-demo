{merge}  = require './helpers.coffee'

# ============================================================

exports.Path = class Path

  constructor: (@shape) ->

  shape: ->
    @shape

# ============================================================

exports.PathBar = class PathBar extends Path

  constructor: (data) ->
    c = transform data
    super "M #{c.x0} #{c.h/2} " +
          "L #{c.x1} #{c.h/2}"

  view: (data, attributes) ->
    data.draw.path( merge attributes,
        "stroke-dasharray":   data.w*.8
        "stroke-dashoffset":  0
        "stroke-width":       data.barwidth*.8
        fill:                 "none"
        d:                    @shape
      )

  transform: (data) ->
    transform data

  transform = (data) ->
    x0 = data.w * .1
    x1 = data.w * .9

    if data.r < 0.0
      x = x0
    else if data.r > 1.0
      x = x1
    else
      x = x0 + (x1 - x0) * data.r

    merge data, { x: x, x0: x0, x1: x1}

# ============================================================
