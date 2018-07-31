{merge}           = require './helpers.coffee'
{settings}      = require './presets.coffee'

# ============================================================

exports.Indicator = class Indicator

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
        when "color"
          indicators.push (new Color(    ptr_id, cfg, data))
        else
          console.log "indicator type '#{cfg.type}' isn't implemented, yet."
    return indicators

  constructor: (@id, config) ->
    @config = settings("indicator", config)


# ============================================================

class Bar extends Indicator

  constructor: (id, config, data) ->
    super id, config
    @elements = @draw_elements(data)
    @update(data)

  update: (data) ->
    @update_bar(data)
    @update_out_of_range(data)

  draw_elements: (data) ->
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

    marker_under = data.svg.defs.add_marker "markerUnder"+@id,
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

    marker_over  = data.svg.defs.add_marker "markerOver"+@id,
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
    width = if @config.width? then @config.width else data.barWidth

    bar = data.svg.derive_path @id, data.path,
      class:                "bar"
      "stroke-width":       width
      stroke:               @config.color
      "stroke-dasharray":   1.0
      "marker-start":       "url('#markerUnder#{@id}')"
      "marker-end":         "url('#markerOver#{@id}')"
    @dash = bar.animate_dash()
    @previous_rl = 0
    return bar



  update_bar:  (data) ->
    rl_from = if @config.invert then @previous_rl-1.5 else 1-@previous_rl
    rl_to   = if @config.invert then -data.rl else 1-data.rl

    @dash.update
      dur:         .5*Math.abs(data.rl-@previous_rl)+"s"
      from:       rl_from
      to:         rl_to
    @dash.beginElement()
    @previous_rl = data.rl

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


class Color extends Indicator

  draw: (data)->
    # nothing

  update: (data) ->
    $("#"+@config.target)[0].setAttribute(
      @config.attribute,
      "hsl(#{200*(1-data.rl)}, 80%, 50%)"
    )


## ============================================================

class Pointer extends Indicator

  defaults:
    type:  "circle"
    color:  "orange"
    radius: 50
    digits: 1
    digit_dy:   -120

  constructor: (id, config, data) ->
    super id, config
    @draw data

  draw: (data) ->

    @group = data.svg.add_group @id

    switch @config.shape

      when "line"
        [x1, x2] = @config.dimension
        @group.add_element "pt"+@id, "line",
          y1:               x1
          y2:               x2
          x1:               0
          x2:               0
          stroke:           @config.color
          "stroke-width":   @config.thickness


    # @pointer = @group.add_shape @id, @config.shape,
    #   "stroke-width": @config.radius/2
    #   fill:           @config.color
    #   r:              @config.radius

    # @digital = @group.add_text "digit"+@id, "Moin?",
    #   "text-anchor":        "middle"
    #   "font-size":          50
    #   color:                "black"
    #   y:                    @config.digit_dy

    @motion = @group.follow_path(data.path)

    @previous_rl = 0
    @update data


  update: (data) ->

    if data.cyclic
      if data.rl-@previous_rl > 0.9
        if data.rl > 0.999
          data.rl = 0
        else
          @previous_rl = 1
      else if data.rl-@previous_rl < -0.9
        if data.rl < 0.001
          data.rl = 1
        else
          @previous_rl = 0

    duration =
      if @config.speed?
        @config.speed
      else
        .5*Math.abs(data.rl-@previous_rl)


    @motion.update
      dur:         duration+"s"
      keyPoints:   @previous_rl+";"+data.rl
    @motion.beginElement()
    # @digital.setText (data.a.toFixed @config.decimals)

    @previous_rl = data.rl


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
    @display.setText @number_unit(data)

  number_unit: (data) ->
    "#{data.a.toFixed(@config.decimals)} #{data.unit}"


## ============================================================
