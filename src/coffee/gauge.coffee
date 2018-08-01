{merge}         = require './helpers.coffee'
{Scale}         = require './scale.coffee'
{SVG}           = require './svg.coffee'
{settings}      = require './presets.coffee'




exports.Gauge = class Gauge

  @store = {}

  @create: (config) ->
    gauges = []
    for gauge_id, cfg of config
      gauges.push (new Gauge(gauge_id, cfg))
    return gauges

  constructor: (@id, config) ->
    Gauge.store[@id] = @

    @config = settings("gauge", config)



    @svg = SVG.add_svg @id, [0, 0, @config.width, @config.height]
    @svg.setup_dragging(@)

    @elements = merge(
      @draw_elements()
      @create_subelements()
    )


  create_subelements: ->
    scales: Scale.create @config.scale, @data()

  draw_elements: ->
    title:  @draw_title()

  draw_title: ->
    @svg.add_text @id, @config.title,
      class:                "title"
      "alignment-baseline": "middle"
      "text-anchor":        "start"
      "font-size":          100
      "font-weight":        "normal"
      x:                    0
      y:                    @config.height * .1

  data: ->
    title:      @config.title
    w:          @config.width
    h:          @config.height
    svg:        @svg

  @setValue: (updates) ->
    for id, update of updates
      @store[id].setValue update

  setValue: (update) ->
    for scale_id, scale of @elements.scales
      scale.setValue @data(), update

  getRelativeLimited: (qty_id) ->
    rl = false
    for scale_id, scale of @elements.scales
      rlx = scale.getRelativeLimited qty_id
      rl = rlx if rlx
    return rl


  getRelative: (qty_id) ->
    r = false
    for scale_id, scale of @elements.scales
      rx = scale.getRelative qty_id
      r = rx if rx
    return r

  setRelative: (qty_id, r) ->
    for scale_id, scale of @elements.scales
      scale.setRelative qty_id, r
