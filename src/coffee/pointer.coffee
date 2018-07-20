{merge}    = require './helpers.coffee'


exports.Pointer = class Pointer

  defaults = {}

  @create: (config) ->
    pointers = []
    for cfg in config
      switch cfg.type
        when "bar"
          pointers.push (new Bar(cfg))
        when "digital"
          pointers.push (new Digital(cfg))
        else
          console.log "pointer type #{cfg.type} isn't implemented, yet."

    return pointers

  constructor: (config) ->
    @config = merge @defaults, config

# ============================================================

class Bar extends Pointer

  defaults:
    barwidth:   100

  path = (data) ->
    "M #{data.x0} #{data.h/2} " +
    "L #{data.x}  #{data.h/2}"

  update:  (data) ->
    data  = @data_bar(data)
    bar   = data.svg.find(".bar")[0];
    bar.setAttribute "d", path data
    update_overflow(data)

  update_overflow = (data) ->
    if data.r < 0.0
      vu = "visible"
      vo  = "hidden"
    else if data.r > 1.0
      vu  = "hidden"
      vo = "visible"
    else
      vo = "hidden"
      vu  = "hidden"

    data.svg.find(".underflow")[0].setAttribute "visibility", vu
    data.svg.find(".overflow" )[0].setAttribute "visibility", vo

  view: (data) ->

    data        = @data_bar(data)
    data_track  = merge data, {x: data.x1}

    data.draw.path
      class:            "track"
      d:                "#{path data_track}"
      "stroke-width":   "#{data.bw}"
      stroke:           "#dddddd"
      fill:             "none"

    data.draw.path
      class:            "bar"
      d:                "#{path data}"
      "stroke-width":   "#{data.bw}"
      stroke:           "#0000ff"
      fill:             "none"

    data.draw.polygon
      visibility:   "hidden"
      class:        'underflow'
      points:       triangle_left(data)
      fill:         "#0000ff"

    data.draw.polygon
      visibility:   "hidden"
      class:        'overflow'
      points:       triangle_right(data)
      fill:         "#0000ff"

  triangle_left = (data) ->
    y  = data.h/2
    dx = dy = data.bw/2
    "0 #{y} " +
    "#{dx} #{y - dy} " +
    "#{dx} #{y + dy}"

  triangle_right = (data) ->
    y  = data.h/2
    dx = dy = data.bw/2
    w  = data.w
    "#{w     } #{y} " +
    "#{w - dx} #{y - dy} " +
    "#{w - dx} #{y + dy}"


  data_bar: (data) ->
    x0 = data.w * .1
    x1 = data.w * .9

    if data.r < 0.0
      x = x0
    else if data.r > 1.0
      x = x1
    else
      x = x0 + (x1 - x0) * data.r

    merge data, { x: x, x0: x0, x1: x1, bw: @config.barwidth}


## ============================================================

class Digital extends Pointer

  update:  (data) ->
    text = data.svg.find(".digital")[0];
    text.textContent = number_unit(data)

  number_unit = (data) ->
    "#{data.a} #{data.unit}"

  view: (data) ->
    data.draw.text number_unit(data),
      class:                "digital"
      "alignment-baseline": "middle"
      "text-anchor":        "end"
      "font-size":          100
      "font-weight":        "bold"
      x:                    data.w
      y:                    data.h * .8
