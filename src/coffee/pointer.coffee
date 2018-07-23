{merge}           = require './helpers.coffee'

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
    @update(data)

  update: (data) ->
    data = merge @defaults, data
    @update_bar(data)
    @update_out_of_range(data)

  draw_elements: (data) ->
    data = merge @defaults, data
    bar  = @draw_bar(data)
    defs = @create_marker_defs(data)

    {
      bar:    bar
      # under:  @draw_underflow(bar, data)
      # over:   @draw_overflow(bar, data)
    }

  create_marker_defs: (data) ->
    defs = data.svg.add_defs "defs"+@id
    marker_under = defs.add_marker "markerUnder",
      orient: "auto"
      fill:         "green"
      # markerWidth:  100
      # markerHeight: 100
      refX:         0
      refY:         0

    poly_under = marker_under.add_polygon "under"+@id,
      # visibility:   "hidden"
      class:        'underflow'
      points:       triangle_left(data)


    marker_over  = defs.add_marker "markerOver",
      orient: "auto"
      fill:         "red"
      markerWidth:  100
      markerHeight: 100
      refX:         0
      refY:         0



    poly_over = marker_over.add_polygon "over"+@id,
      # visibility:   "hidden"
      class:        'overflow'
      points:       triangle_right(data)


  draw_bar: (data) ->
    data.svg.derive_path "bar"+@id, data.path,
      class:                "bar"
      "stroke-width":       data.barWidth
      stroke:               @config.barColor
      # "stroke-dasharray":   1.0
      "marker-start":       "url(#markerUnder)"
      "marker-end":         "url(#markerOver)"

  update_bar:  (data) ->
    @elements.bar.node.setAttribute(
      "stroke-dashoffset"
      1.0 - data.rl
    )

  # draw_underflow: (data) ->
  #   data.svg.add_polygon "under"+@id,
  #     visibility:   "hidden"
  #     class:        'underflow'
  #     points:       triangle_left(data)
  #     fill:         @config.barColor
  #
  # draw_overflow: (data) ->
  #   data.svg.add_polygon "over"+@id,
  #     visibility:   "hidden"
  #     class:        'overflow'
  #     points:       triangle_right(data)
  #     fill:         @config.barColor

  triangle_left = (data) ->
    "0 0 50 -50 50 50"
    #
    # "0 #{y} " +
    # "#{dx} #{y - dy} " +
    # "#{dx} #{y + dy}"

  triangle_right = (data) ->
    y  = 0
    dx = dy = data.barWidth/2
    w  = 0
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

    # @elements.under.node.setAttribute "visibility", vu
    # @elements.over.node.setAttribute "visibility", vo

## ============================================================

class Marker extends Pointer

  defaults:
    type:  "circle"
    color:  "yellow"
    radius: 25

  constructor: (id, config, data) ->
    super id, config
    @draw data

  draw: (data) ->
    @marker = data.svg.add_shape @id, @config.shape,
      "stroke-width": @config.radius/2
      fill:           @config.color
      r:              @config.radius
    @update data

  update: (data) ->
    coord = data.path.position data.rl
    @marker.update
      cx:   coord.x
      cy:   coord.y

    if 0.0 < data.r < 1.0
      @marker.update
        fill:   @config.color
        stroke: "none"
    else
      @marker.update
        fill:   "none"
        stroke: @config.color


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
