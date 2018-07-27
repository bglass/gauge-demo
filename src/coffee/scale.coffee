{merge, filter, round} = require './helpers.coffee'
{Quantity}      = require './quantity.coffee'
# {Horizontal}    = require './path.coffee'

# ============================================================

exports.Scale = class Scale

  defaults:
    label:            "no label"
    unit:             "°C"
    type:             "horizontal"
    v0:               10
    v1:               30
    track:
      color:          "lightgrey"
    barWidth:         100
    tick:
      width:        200
      thickness:    1/100
      divisions:    2
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
      divisions:    10
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
    segments: @draw_segments data

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

    group = data.svg.add_group "ticks"+@id

    for i in [0..@config.tick.divisions]
      group.add_line





  #   data.svg.new_path "ticks"+@id, (merge @config, data),
  #     class:                "ticks"
  #     "stroke-width":       @config.tick.width
  #     stroke:               @config.tick.color
  #     "stroke-dasharray":   tick_definition(@config.tick)
  #
  draw_subticks: (data) ->
  #   data.svg.new_path "subt"+@id, (merge @config, data),
  #     class:                "subt"
  #     "stroke-width":       @config.subtick.width
  #     stroke:               @config.subtick.color
  #     "stroke-dasharray":   tick_definition(@config.subtick)

  draw_track: (data) ->
    @path_template =
    data.svg.new_path "track"+@id, (merge @config, data),
        class:                "track"
        "stroke-width":       @config.barWidth
        stroke:               @config.track.color

  relative_value = (data, value) ->
    (value - data.v0) / (data.v1 - data.v0)

  draw_segments: (data) ->
    if @config.track.segments
      @config.track.segments.map (segment, i) =>
        [color, start, stop] = segment.split(" ")

        a = relative_value @config, start
        b = relative_value @config, stop

        if a < 0 then a = 0
        if b > 1 then b = 1

        data.svg.derive_path @id+"segment"+i, @path_template,
          stroke:               color
          "stroke-width":       @config.barWidth
          "stroke-dasharray":   "#{b-a} #{1+a-b}"
          "stroke-dashoffset":  -a

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
