{merge}    = require './helpers.coffee'
{Quantity} = require './quantity.coffee'
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
    @quantities = Quantity.create @config.quantity, @init()
    @attach()

  attach: ->
    v = @view()
    $("div#"+@id).append @view()
    @svg = $("svg#"+@id)

  view: ->
    @draw = new Drawing(@id, @config.width, @config.height)
    @view_title()
    @view_quantities()
    return @draw.get()

  view_quantities: ->
    for id, quantity of @quantities
      quantity.view @data()

  view_title: ->
    @draw.text @config.title,
      class:                "title"
      "alignment-baseline": "middle"
      "text-anchor":        "start"
      "font-size":          100
      "font-weight":        "normal"
      x:                    0
      y:                    @config.height * .8

  init: ->
    title:      @config.title
    w:          @config.width
    h:          @config.height

  data: ->
    merge @init(),
      draw:       @draw
      svg:        $("svg#" + @id)

  @setValue: (update) ->
    for id, data of update
      @store[id].setValue data

  setValue: (update) ->
    for qty, value of update
      @quantities[qty].setValue @data(), value
