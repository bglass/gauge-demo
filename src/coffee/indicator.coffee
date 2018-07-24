{merge}           = require './helpers.coffee'

# ============================================================

exports.Indicator = class Indicator

  defaults: {}

  @create: (config, data) ->

    indicators = []
    for ptr_id, cfg of config
      switch cfg.type
        when "bar"
          indicators.push (new Bar(     ptr_id, cfg, data))
        when "digital"
          indicators.push (new Digital( ptr_id, cfg, data))
        when "pointer"
          indicators.push (new Pointer(  ptr_id, cfg, data))
        else
          console.log "indicator type '#{cfg.type}' isn't implemented, yet."
    return indicators

  constructor: (@id, config) ->
    @config = merge @defaults, config

# ============================================================

class Bar extends Indicator

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
      under:  $("svg").find("#underflow"+@id)[0]
      over:   $("svg").find("#overflow"+@id)[0]
    }

  create_marker_defs: (data) ->
    triangle_left  = ".5,0 1,.5 .5,1"
    triangle_right = "0,.5 .5,0 .5,1"
    defs = data.svg.add_defs "defs"+@id
    marker_under = defs.add_marker "markerUnder"+@id,
      orient: "auto"
      fill:         "skyblue"
      markerWidth:  1
      markerHeight: 1
      refX:         .75
      refY:         .5

    poly_under = marker_under.add_polygon "underflow"+@id,
      visibility:   "hidden"
      class:        'underflow'
      points:       triangle_right


    marker_over  = defs.add_marker "markerOver"+@id,
      orient: "auto"
      fill:         "tomato"
      markerWidth:  1
      markerHeight: 1
      refX:         .25
      refY:         .5

    poly_over = marker_over.add_polygon "overflow"+@id,
      visibility:   "hidden"
      class:        'overflow'
      points:       triangle_left

  draw_bar: (data) ->
    data.svg.derive_path "bar"+@id, data.path,
      class:                "bar"
      "stroke-width":       data.barWidth
      stroke:               @config.barColor
      "stroke-dasharray":   1.0
      "marker-start":       "url('#markerUnder#{@id}')"
      "marker-end":         "url('#markerOver#{@id}')"

  update_bar:  (data) ->
    @elements.bar.node.setAttribute(
      "stroke-dashoffset"
      1.0 - data.rl
    )

  update_out_of_range: (data) ->
    if data.r < 0.0
      vu = "visible"
    else
      vu = "hidden"

    if data.r > 1.0
      vo = "visible"
    else
      vo = "hidden"

    @elements.under.setAttribute "visibility", vu
    @elements.over.setAttribute "visibility", vo

## ============================================================

class Pointer extends Indicator

  defaults:
    type:  "circle"
    color:  "orange"
    radius: 50

  constructor: (id, config, data) ->
    super id, config
    @draw data

  draw: (data) ->
    @pointer = data.svg.add_shape @id, @config.shape,
      "stroke-width": @config.radius/2
      fill:           @config.color
      r:              @config.radius
    @motion = @pointer.follow_path(data.path)
    @previous = 0
    @update data


  update: (data) ->

    @motion.update
      keyPoints:        @previous + ";" + data.rl
    @previous = data.rl

    # coord = data.path.position data.rl
    # @pointer.update
    #   cx:   coord.x
    #   cy:   coord.y

    # if 0.0 < data.r < 1.0
    #   @pointer.update
    #     fill:   @config.color
    #     stroke: "none"
    # else
    #   @pointer.update
    #     fill:   "none"
    #     stroke: @config.color


## ============================================================

class Digital extends Indicator

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
