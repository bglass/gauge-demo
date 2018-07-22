{merge}  = require './helpers.coffee'

# ============================================================

class Path

  constructor: (@shape) ->

  shape: ->
    @shape


# ============================================================

exports.PathH = class PathH extends Path

  constructor: (data) ->
    c = transform data
    super "M #{c.x0} #{c.h/2} " +
          "L #{c.x1} #{c.h/2}"

  transform: (data) ->
    transform data

  transform = (data) ->
    x0 = data.w * .1
    x1 = data.w * .9
    x = x0 + (x1 - x0) * data.rl

    merge data, { x: x, x0: x0, x1: x1}

# ============================================================
