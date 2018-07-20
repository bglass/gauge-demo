{merge}    = require './helpers.coffee'
{Quantity} = require './quantity.coffee'
{Drawing}  = require './drawing.coffee'

exports.Gauge = class Gauge

  defaults:
    title: ""
    pointer: {}
    width: 1000
    height: 500

  @create: (config) ->
    gauges = []
    for gauge_id, cfg of config
      gauges.push (new Gauge(gauge_id, cfg))
    return gauges

  constructor: (@id, config) ->
    @config = merge @defaults, config
    @quantities = Quantity.create @config.quantity
    @attach()

  attach: ->
    v = @view()
    $("div#"+@id).append @view()
    @svg = $("svg#"+@id)

  view: ->
    @draw = new Drawing(@id, @config.width, @config.height)

    @view_title()

    return @draw.get()



  view_title: ->
    @draw.text @config.title,
      class:                "title"
      "alignment-baseline": "middle"
      "text-anchor":        "start"
      "font-size":          100
      "font-weight":        "normal"
      x:                    0
      y:                    @config.height * .8
