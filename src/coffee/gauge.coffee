{merge}    = require './helpers.coffee'
{Scale}    = require './scale.coffee'
{SVG}      = require './svg.coffee'

exports.Gauge = class Gauge

  @store = {}

  defaults:
    title: ""
    width: 1000
    height: 500

  @create: (config) ->
    gauges = []
    for gauge_id, cfg of config
      gauges.push (new Gauge(gauge_id, cfg))
    return gauges

  constructor: (@id, config) ->
    Gauge.store[@id] = @
    @config = merge @defaults, config

    @svg = SVG.add_viewbox @id, [0, 0, @config.width, @config.height]
    @draw_elements()
    @create_subelements()


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
    for scale_id, scale of @scales
      scale.setValue @data(), update
