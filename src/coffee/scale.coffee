{merge, filter} = require './helpers.coffee'
{Quantity}      = require './quantity.coffee'
{PathH}         = require './path.coffee'

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
      switch cfg.type
        when "horizontal"
          scale[scale_id] = new Horizontal(scale_id, cfg, data)
        else
          scale[scale_id] = new Horizontal(scale_id, cfg, data)
          # console.log "path type '#{cfg.type}' isn't implemented, yet."
    return scale

  constructor: (@id, @path, config, data) ->
    @config = merge @defaults, config

    @draw_elements(data)
    @create_subelements(data)


  create_subelements: (data) ->

  draw_elements: (data) ->
    ticks:  @draw_ticks data
    track:  @draw_track data

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



  # setValue: (data, update) ->
  #   for qty, value of update
  #     @quantities[qty].setValue (merge data, @data()), value
  #
  # view: (data) ->
  #   # label
  #   @view_label(data)
  #
  #
  #   # track
  #   @path.view (merge @config, data),
  #     class:            "track"
  #     stroke:           @config.trackColor
  #
  #   # pointers (via quantities)
  #   for qty_id, quantity of @quantities
  #     quantity.view(merge data, @data())
  #
  # init: (data) ->
  #
  #   # ticks
  #   data   = @path.transform(data)
  #   ticks  = data.svg.find(".ticks")[0];
  #   @path.setup_ticks(ticks, (merge data, @data()))
  #
  #   # pointers (via quantities)
  #   for qty_id, quantity of @quantities
  #     quantity.init(merge data, @data())
  #
  # data: ->
  #   barwidth:         @config.barwidth
  #   unit:             @config.unit
  #   v0:               @config.v0
  #   v1:               @config.v1
  #   path:             @path
  #   tickWidth:        @config.tickWidth
  #   tickThickness:    @config.tickThickness
  #   tickDivisions:    @config.tickDivisions
  #
  # view_label: (data)->
  #   data.draw.text @config.label,
  #     class:                "label"
  #     "alignment-baseline": "middle"
  #     "text-anchor":        "start"
  #     "font-size":          100
  #     "font-weight":        "normal"
  #     x:                    0
  #     y:                    data.h * .8


# ============================================================

exports.Horizontal = class Horizontal extends Scale

  constructor: (id, config, data) ->
    path = new PathH (merge config, data)
    super id, path, config, data
