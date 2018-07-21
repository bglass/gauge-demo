{merge}        = require './helpers.coffee'
{Quantity}     = require './quantity.coffee'
{PathH}        = require './path.coffee'

# ============================================================

exports.Scale = class Scale

  defaults:
    label:            "no label"
    unit:             "dC"
    v0:               10
    v1:               30
    barwidth:         100
    tickWidth:        150
    tickThickness:    4
    tickDivisions:    4
    type:             "horizontal"
    trackColor:       "#dddddd"
    tickColor:        "black"

  @create: (config, data0) ->
    scale = {}
    for scale_id, cfg of config
      switch cfg.type
        when "horizontal"
          scale[scale_id] = new Horizontal(scale_id, cfg, data0)
        else
          scale[scale_id] = new Horizontal(scale_id, cfg, data0)
          # console.log "path type '#{cfg.type}' isn't implemented, yet."
    return scale

  constructor: (@id, config, data0) ->
    @config = merge @defaults, config
    @quantities = Quantity.create @config.quantity, (merge data0, @data())

  setValue: (data, update) ->
    for qty, value of update
      @quantities[qty].setValue (merge data, @data()), value

  view: (data) ->
    # label
    @view_label(data)

    # ticks
    @path.view_ticks (merge @config, data),
      class:            "ticks"
      stroke:           @config.tickColor

    # track
    @path.view (merge @config, data),
      class:            "track"
      stroke:           @config.trackColor

    # pointers (via quantities)
    for qty_id, quantity of @quantities
      quantity.view(merge data, @data())

  init: (data) ->

    # ticks
    data   = @path.transform(data)
    ticks  = data.svg.find(".ticks")[0];
    @path.setup_ticks(ticks, (merge data, @data()))

    # pointers (via quantities)
    for qty_id, quantity of @quantities
      quantity.init(merge data, @data())

  data: ->
    barwidth:         @config.barwidth
    unit:             @config.unit
    v0:               @config.v0
    v1:               @config.v1
    path:             @path
    tickWidth:        @config.tickWidth
    tickThickness:    @config.tickThickness
    tickDivisions:    @config.tickDivisions

  view_label: (data)->
    data.draw.text @config.label,
      class:                "label"
      "alignment-baseline": "middle"
      "text-anchor":        "start"
      "font-size":          100
      "font-weight":        "normal"
      x:                    0
      y:                    data.h * .8


# ============================================================

exports.Horizontal = class Horizontal extends Scale

  constructor: (id, config, data0) ->
    super id, config, data0
    @path = new PathH (merge config, data0)
