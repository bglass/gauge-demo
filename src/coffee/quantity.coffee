{merge}    = require './helpers.coffee'
{Pointer}  = require './pointer.coffee'

exports.Quantity = class Quantity

  defaults:
    value: 77.0
    unit: "K"
    pointer: [{type: "bar"}, {type: "digital"}]
    v0:  0
    v1:  100

  @create: (config, init) ->
    quantity = {}
    for qty_id, cfg of config
      quantity[qty_id] = new Quantity(qty_id, cfg, init)
    return quantity

  constructor: (@id, config, init) ->
    @config = merge @defaults, config
    @value = @config.value
    @pointers = Pointer.create @config.pointer, (merge init, @data())

  data: ->  
    a:    @value
    r:    (@value - @config.v0) / (@config.v1 - @config.v0)
    v0:   @config.v0
    v1:   @config.v1
    unit: @config.unit

  view: (data) ->
    for pointer in @pointers
      pointer.view(merge data, @data())

  setValue: (data, @value) ->
    for pointer in @pointers
      pointer.update(merge data, @data())
