{merge, filter, round} = require './helpers.coffee'
{Quantity}      = require './quantity.coffee'
{Generate}      = require './generate.coffee'
# {Horizontal}    = require './path.coffee'

# ============================================================

exports.Scale = class Scale

  defaults:
    label:            "no label"
    unit:             "dC"
    type:             "horizontal"
    v0:               10
    v1:               30
    track:
      color:          "lightgrey"
    barWidth:         100
    tick:
      width:        200
      thickness:    1/100
      divisions:    4
      v0:               10
      v1:               30
      color:          "black"
    number:
      v0:               10
      v1:               30
      divisions:        2
    subtick:
      width:        130
      thickness:    1/100
      divisions:    8
      v0:               10
      v1:               30
      color:          "black"


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
    ticks:    @draw_ticks    data
    subticks: @draw_subticks data
    track:    @draw_track    data
    label:    @draw_label    data
    scaling:  @draw_scaling  data

  draw_scaling: (data) ->
    cfg = @config.number
    for v,i in tick_values cfg
      r = (v - cfg.v0) / (cfg.v1 - cfg.v0)
      p = @path_template.offset(r, -180.0)


      group = data.svg.add_group @id+"G"+i,
        transform:               "rotate (#{p.phi} #{p.x} #{p.y})"

      number = group.add_text @id+"S"+i, round(v,1),
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
      "stroke-width":       @config.tick.width
      stroke:               @config.tick.color
    ticks.node.setAttribute "stroke-dasharray",
                            tick_definition(@config.tick)
    return ticks

  draw_subticks: (data) ->
    subticks = data.svg.new_path "subt"+@id, (merge @config, data),
      class:                "subt"
      "stroke-width":       @config.subtick.width
      stroke:               @config.subtick.color
    subticks.node.setAttribute "stroke-dasharray",
                            tick_definition(@config.subtick)
    return subticks

  draw_track: (data) ->
    Generate.gradient()
    @path_template =
      data.svg.new_path "track"+@id, (merge @config, data),
        class:                "track"
        "stroke-width":       @config.barWidth
        stroke:               @config.track.color

  tick_definition = (tick) ->
    a = tick.thickness
    n = tick.divisions
    b = (1 - a*(n+1) ) / n
    return "#{a} #{b}"

  tick_values = (tick) ->
    n = tick.divisions
    [0..n].map (i) ->
      tick.v0 + i/n*(tick.v1-tick.v0)



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
