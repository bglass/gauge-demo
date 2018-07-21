{merge}    = require './helpers.coffee'
{Pointer}  = require './pointer.coffee'

exports.Quantity = class Quantity

  defaults:
    value: 77.0
    pointer: [{type: "bar"}, {type: "digital"}]

  @create: (config, data0) ->
    quantity = {}
    for qty_id, cfg of config
      quantity[qty_id] = new Quantity(qty_id, cfg, data0)
    return quantity

  constructor: (@id, config, data0) ->
    @config = merge @defaults, config
    @value = @config.value
    @pointers = Pointer.create @config.pointer, (@data_fill data0)


  data_fill: (data) ->
    data.a  = @value
    data.r  = @relative_value(data)
    data.rl = @limited_value(data)
    return data

  relative_value: (data) ->
    (@value - data.v0) / (data.v1 - data.v0)

  limited_value: (data)->
    r = @relative_value(data)
    if r < 0.0
      return 0.0
    else if r > 1.0
      return 1.0
    else
      return r


  init: (data) ->
    for pointer in @pointers
      pointer.init(@data_fill data)

  view: (data) ->
    for pointer in @pointers
      pointer.view(@data_fill data)

  setValue: (data, @value) ->
    for pointer in @pointers
      pointer.update(@data_fill data)
