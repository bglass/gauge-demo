{merge}           = require './helpers.coffee'
{Circle}          = require './shape.coffee'

# ============================================================

exports.Pointer = class Pointer

  defaults: {}

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

  defaults:
    barColor:       "#0000ff"

  constructor: (id, config, data) ->
    super id, config

    @elements = @draw_elements(data)
    @setup_bar()
    @update(data)

  update: (data) ->
    @update_bar(data)
    @update_out_of_range(data)

  draw_elements: (data) ->
    bar:    @draw_bar(data)
    under:  @draw_underflow(data)
    over:   @draw_overflow(data)

  draw_bar: (data) ->
    data = merge @defaults, data.path.transform(data)
    data.svg.add_path "bar"+@id, data.path,
      class:                "bar"
      "stroke-width":       data.barWidth
      stroke:               @config.barColor

  setup_bar: ->
    @path_length = @elements.bar.path_length()
    @elements.bar.node.setAttribute "stroke-dasharray", @path_length

  update_bar:  (data) ->
    data  = data.path.transform(data)
    @elements.bar.node.setAttribute(
      "stroke-dashoffset"
      @path_length * (1.0 - data.rl)
    )

  draw_underflow: (data) ->
    data.svg.add_polygon "under"+@id,
      visibility:   "hidden"
      class:        'underflow'
      points:       triangle_left(data)
      fill:         @config.barColor

  draw_overflow: (data) ->
    data.svg.add_polygon "over"+@id,
      visibility:   "hidden"
      class:        'overflow'
      points:       triangle_right(data)
      fill:         @config.barColor

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


  update_out_of_range: (data) ->
    if data.r < 0.0
      vu = "visible"
    else
      vu = "hidden"

    if data.r > 1.0
      vo = "visible"
    else
      vo = "hidden"

    @elements.under.node.setAttribute "visibility", vu
    @elements.over.node.setAttribute "visibility", vo

## ============================================================

class Marker extends Pointer

  defaults:
    type:  "circle"
    color:  "green"
    radius: 25

  constructor: (id, config, data) ->
    super id, config
    @draw data

  draw: (data) ->
    @marker = data.svg.add_shape @id, @config.shape,
      fill: @config.color
      r:    @config.radius
    @update data

  update: (data) ->
    console.log data
    @marker.update
      cx:   500
      cy:    50



## ============================================================

class Digital extends Pointer

  constructor: (id, config, data) ->
    super id, config
    @draw data

  draw: (data) ->
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
