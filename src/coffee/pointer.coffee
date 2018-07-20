{merge}    = require './helpers.coffee'


exports.Pointer = class Pointer

  defaults:
    barwidth:   100

  @create: (config) ->
    pointers = []
    for cfg in config
      pointers.push (new Pointer(cfg))
    return pointers

  constructor: (config) ->
    @config = merge @defaults, config

  update: (data) ->
    switch @config.type
      when "digital"
        @update_digital(data)
      when "bar"
        @update_bar(data)
      when "marker"
      else

  update_digital:  (data) ->
    text = data.svg.find(".digital")[0];
    text.textContent = number_unit(data)

  update_bar:  (data) ->
    data  = @data_bar(data)
    bar   = data.svg.find(".bar")[0];
    bar.setAttribute "d", path_bar data
    update_bar_overflow(data)

  update_bar_overflow = (data) ->

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


  view: (data) ->
    switch @config.type
      when "digital"
        @view_digital(data)
      when "bar"
        @view_bar(data)
      when "marker"
        console.log "marker to be implemented."
      else
        console.log "pointer type isn't implemented, yet."

  number_unit = (data) ->
    "#{data.a} #{data.unit}"

  view_digital: (data) ->
    data.draw.text number_unit(data),
      class:                "digital"
      "alignment-baseline": "middle"
      "text-anchor":        "end"
      "font-size":          100
      "font-weight":        "bold"
      x:                    data.w
      y:                    data.h * .8

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




  view_bar: (data) ->

    data        = @data_bar(data)
    data_track  = merge data, {x: data.x1}

    data.draw.path
      class:            "bar_track"
      d:                "#{path_bar data_track}"
      "stroke-width":   "#{data.bw}"
      stroke:           "#aaaaaa"
      fill:             "none"

    data.draw.path
      class:            "bar"
      d:                "#{path_bar data}"
      "stroke-width":   "#{data.bw}"
      stroke:           "#0000ff"
      fill:             "none"

    data.draw.polygon
      visibility:   "hidden"
      class:        'underflow'
      points:       poly_triangle_left(data)
      fill:         "#0000ff"

    data.draw.polygon
      visibility:   "hidden"
      class:        'overflow'
      points:       poly_triangle_right(data)
      fill:         "#0000ff"



  poly_triangle_left = (data) ->
    y  = data.h/2
    dx = dy = data.bw/2
    "0 #{y} " +
    "#{dx} #{y - dy} " +
    "#{dx} #{y + dy}"

  poly_triangle_right = (data) ->
    y  = data.h/2
    dx = dy = data.bw/2
    w  = data.w
    "#{w     } #{y} " +
    "#{w - dx} #{y - dy} " +
    "#{w - dx} #{y + dy}"






  path_bar = (data) ->
    "M #{data.x0} #{data.h/2} " +
    "L #{data.x}  #{data.h/2}"
