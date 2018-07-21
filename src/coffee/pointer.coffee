{merge}           = require './helpers.coffee'
{Path, PathBar}   = require './path.coffee'

# ============================================================

exports.Pointer = class Pointer

  defaults = {}

  @create: (config, init) ->
    pointers = []
    for cfg in config
      switch cfg.type
        when "bar"
          pointers.push (new Bar(cfg, init))
        when "digital"
          pointers.push (new Digital(cfg))
        else
          console.log "pointer type '#{cfg.type}' isn't implemented, yet."
    return pointers

  constructor: (config) ->
    @config = merge @defaults, config

# ============================================================

class Bar extends Pointer

  defaults:
    barwidth:   100

  constructor: (config, init) ->
    super config
    @path = new PathBar init

  update:  (data) ->
    data  = @path.transform(data)
    bar   = data.svg.find(".bar")[0];
    bar.setAttribute "stroke-dashoffset", - data.r *(data.w*.8)
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

    data        = merge @defaults, @path.transform(data)

    @path.view data,
      class:            "track"
      stroke:           "#dddddd"

    @path.view data,
      class:                "bar"
      stroke:               "#0000ff"

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
    dx = dy = data.barwidth/2
    "0 #{y} " +
    "#{dx} #{y - dy} " +
    "#{dx} #{y + dy}"

  triangle_right = (data) ->
    y  = data.h/2
    dx = dy = data.barwidth/2
    w  = data.w
    "#{w     } #{y} " +
    "#{w - dx} #{y - dy} " +
    "#{w - dx} #{y + dy}"

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

## ============================================================
