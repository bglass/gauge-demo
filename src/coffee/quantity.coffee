{merge}    = require './helpers.coffee'
{Pointer}  = require './pointer.coffee'

exports.Quantity = class Quantity

  defaults:
    value: 77.0
    unit: "K"
    pointer: [{type: "bar"}, {type: "digital"}]
    v0:  0
    v1:  100

  @create: (config, data0) ->
    quantity = {}
    for qty_id, cfg of config
      quantity[qty_id] = new Quantity(qty_id, cfg, data0)
    return quantity

  constructor: (@id, config, data0) ->
    @config = merge @defaults, config
    @value = @config.value
    @pointers = Pointer.create @config.pointer, (merge data0, @data())


  relative_value: ->
    (@value - @config.v0) / (@config.v1 - @config.v0)

  limited_value: ->
    r = @relative_value()
    if r < 0.0
      return 0.0
    else if r > 1.0
      return 1.0
    else
      return r

  data: ->  
    a:    @value
    r:    @relative_value()
    rl:   @limited_value()
    v0:   @config.v0
    v1:   @config.v1
    unit: @config.unit

  init: (data) ->
    for pointer in @pointers
      pointer.init(merge data, @data())

  view: (data) ->
    for pointer in @pointers
      pointer.view(merge data, @data())

  setValue: (data, @value) ->
    for pointer in @pointers
      pointer.update(merge data, @data())
