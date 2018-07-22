{merge}           = require './helpers.coffee'
{Circle}          = require './shape.coffee'

# ============================================================

exports.Pointer = class Pointer

  defaults = {}

  @create: (config, data) ->
    pointers = []
    for ptr_id, cfg of config
      switch cfg.type
        when "bar"
          pointers.push (new Bar(     ptr_id, cfg, data))
        when "digital"
          pointers.push (new Digital( ptr_id, cfg, data))
        when "marker"
          pointers.push (new Marker(  ptr_id, cfg, data))
        else
          console.log "pointer type '#{cfg.type}' isn't implemented, yet."
    return pointers

  constructor: (@id, config) ->
    @config = merge @defaults, config

# ============================================================

class Bar extends Pointer


  update:  (data) ->
    # data  = data.path.transform(data)
    # bar   = data.svg.find(".bar")[0];
    # data.path.update(bar, data)
    # update_overflow(data)

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

    data        = merge @defaults, data.path.transform(data)

    data.path.view data,
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
    dx = dy = data.barWidth/2
    "0 #{y} " +
    "#{dx} #{y - dy} " +
    "#{dx} #{y + dy}"

  triangle_right = (data) ->
    y  = data.h/2
    dx = dy = data.barWidth/2
    w  = data.w
    "#{w     } #{y} " +
    "#{w - dx} #{y - dy} " +
    "#{w - dx} #{y + dy}"

## ============================================================

class Marker extends Pointer

  view: (data) ->

  defaults:
    size:   50
    type:  "circle"
    color:  "green"

  constructor: (config, data0) ->
    super config
    switch config.type
      when "circle"
        @shape = new Circle @config


## ============================================================

class Digital extends Pointer

  constructor: (id, config, data) ->
    super id, config
    @draw_display data

  draw_display: (data) ->
    @display = data.svg.add_text @id, "",
      class:                "digital"
      "alignment-baseline": "middle"
      "text-anchor":        "end"
      "font-size":          100
      "font-weight":        "bold"
      x:                    data.w
      y:                    data.h * .8
    @update data

  update:  (data) ->
    @display.node.textContent = number_unit(data)

  number_unit = (data) ->
    "#{data.a} #{data.unit}"


## ============================================================
