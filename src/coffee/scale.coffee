{merge, filter} = require './helpers.coffee'
{Quantity}      = require './quantity.coffee'
{Generate}      = require './generate.coffee'
# {Horizontal}    = require './path.coffee'

# ============================================================

exports.Scale = class Scale

  defaults:
    label:            "no label"
    unit:             "dC"
    v0:               10
    v1:               30
    barWidth:         100
    tickWidth:        150
    tickThickness:    1/100
    tickDivisions:    4
    type:             "horizontal"
    trackColor:       "#dddddd"
    tickColor:        "black"

  @create: (config, data) ->
    scale = {}
    for scale_id, cfg of config
      scale[scale_id] = new Scale(scale_id, cfg, data)
    return scale

  constructor: (@id, config, data) ->
    @config = merge @defaults, config


    @elements = merge(
      @draw_elements(data)
      @create_subelements(data)
    )

  create_subelements: (data) ->
    quantities:   Quantity.create @config.quantity, @refine(data)

  refine: (data) ->
    barWidth:         @config.barWidth
    unit:             @config.unit
    v0:               @config.v0
    v1:               @config.v1
    path:             @path_template
    svg:              data.svg
    w:                data.w
    h:                data.h

  draw_elements: (data) ->
    ticks:    @draw_ticks   data
    track:    @draw_track   data
    label:    @draw_label   data
    scaling:  @draw_scaling data

  draw_scaling: (data) ->
    p = @path_template.offset(0.5, -120.0)
    console.log p
    data.svg.add_text "scaling"+@id, 88,
      class:                "scaling"
      "alignment-baseline": "middle"
      "text-anchor":        "middle"
      "font-size":          100
      "font-weight":        "normal"
      x:                    p.x
      y:                    p.y



  draw_ticks: (data) ->
    ticks = data.svg.new_path "ticks"+@id, (merge @config, data),
      class:                "ticks"
      "stroke-width":       @config.tickWidth
      stroke:               @config.tickColor
    ticks.node.setAttribute "stroke-dasharray",
                            tick_definition(ticks, @config)
    return ticks

  draw_track: (data) ->
    Generate.gradient()
    @path_template =
      data.svg.new_path "track"+@id, (merge @config, data),
        class:                "track"
        "stroke-width":       @config.barWidth
        stroke:               @config.trackColor


  tick_definition = (tag, cfg) ->
    a = cfg.tickThickness
    n = cfg.tickDivisions
    b = (1 - a*(n+1) ) / n
    return "#{a} #{b}"

  draw_label: (data) ->
    data.svg.add_text @id, @config.label,
      class:                "label"
      "alignment-baseline": "middle"
      "text-anchor":        "start"
      "font-size":          100
      "font-weight":        "normal"
      x:                    0
      y:                    data.h * .8


  setValue: (data, update) ->
    for qty, value of update
      @elements.quantities[qty].setValue @refine(data), value



# ============================================================
