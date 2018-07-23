{merge}    = require './helpers.coffee'
{Pointer}  = require './pointer.coffee'

exports.Quantity = class Quantity

  defaults:
    value: 77.0
    pointer: [{type: "bar"}, {type: "digital"}]

  @create: (config, data) ->
    quantity = {}
    for qty_id, cfg of config
      quantity[qty_id] = new Quantity(qty_id, cfg, data)
    return quantity

  constructor: (@id, config, data) ->
    @config = merge @defaults, config
    @value = @config.value

    # console.log data


    @pointers = Pointer.create @config.pointer, @refine data,


  refine: (data) ->
    merge data,
      a:      @value
      r:      @relative_value(data)
      rl:     @limited_value(data)

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


  setValue: (data, @value) ->
    for pointer in @pointers
      pointer.update(@refine data)
