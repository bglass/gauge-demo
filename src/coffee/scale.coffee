{merge, filter} = require './helpers.coffee'
{Quantity}      = require './quantity.coffee'
{Horizontal}    = require './path.coffee'

# ============================================================

exports.Scale = class Scale

  defaults:
    label:            "no label"
    unit:             "dC"
    v0:               10
    v1:               30
    barWidth:         100
    tickWidth:        150
    tickThickness:    4
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

    switch @config.type
      when "horizontal"
        @path = new Horizontal (merge @config, data)
      else
        @path = new Horizontal (merge @config, data)

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
    path:             @path
    svg:              data.svg
    w:                data.w
    h:                data.h

  draw_elements: (data) ->
    ticks:  @draw_ticks data
    track:  @draw_track data
    label:  @draw_label data

  draw_track: (data) ->
    data.svg.add_path "track"+@id, @path,
      class:                "track"
      "stroke-width":       @config.barWidth
      stroke:               @config.trackColor

  draw_ticks: (data) ->
    ticks = data.svg.add_path "ticks"+@id, @path,
      class:                "ticks"
      "stroke-width":       @config.tickWidth
      stroke:               @config.tickColor
    ticks.node.setAttribute "stroke-dasharray",
                            tick_definition(ticks, @config)

  tick_definition = (tag, cfg) ->
    l = tag.node.getTotalLength()
    a = cfg.tickThickness
    n = cfg.tickDivisions
    b = (l-a*(n+1))/n
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
