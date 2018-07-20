{merge}    = require './helpers.coffee'
{Pointer}  = require './pointer.coffee'

exports.Quantity = class Quantity

  defaults:
    value: 77.0
    unit: "K"
    pointer: [{type: "bar"}, {type: "digital"}]
    v0:  0
    v1:  100

  @create: (config) ->
    quantity = {}
    for qty_id, cfg of config
      quantity[qty_id] = new Quantity(qty_id, cfg)
    return quantity

  constructor: (@id, config) ->
    @config = merge @defaults, config
    @pointers = Pointer.create @config.pointer
    @value = @config.value

  relative_value: (cfg, quantity)->
    (@value - @config.v0) / (@config.v1 - @config.v0)

  data: ->  
    a:    @value
    r:    @relative_value()
    v0:   @config.v0
    v1:   @config.v1
    unit: @config.unit

  view: (data) ->
    for pointer in @pointers
      pointer.view(merge data, @data())

  setValue: (data, @value) ->
    for pointer in @pointers
      pointer.update(merge data, @data())
