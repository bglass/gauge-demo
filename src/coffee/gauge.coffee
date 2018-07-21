{merge}    = require './helpers.coffee'
{Scale}    = require './scale.coffee'
{Drawing}  = require './drawing.coffee'

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
    @scales = Scale.create @config.scale, @data0()
    @attach()
    @init()

  attach: ->
    @view()
    $("div#"+@id).append @draw.get()
    @svg = $("svg#"+@id)

  init: ->
    for id, scale of @scales
      scale.init @data()

  view: ->
    @draw = new Drawing(@id, @config.width, @config.height)
    @view_title()
    @view_scales()

  view_scales: ->
    for id, scale of @scales
      scale.view @data()

  view_title: ->
    @draw.text @config.title,
      class:                "title"
      "alignment-baseline": "middle"
      "text-anchor":        "start"
      "font-size":          100
      "font-weight":        "normal"
      x:                    0
      y:                    @config.height * .1

  data0: ->
    title:      @config.title
    w:          @config.width
    h:          @config.height

  data: ->
    merge @data0(),
      draw:       @draw
      svg:        $("svg#" + @id)

  @setValue: (update) ->
    for id, data of update
      @store[id].setValue data

  setValue: (update) ->
    for scale_id, scale of @scales
      scale.setValue update
