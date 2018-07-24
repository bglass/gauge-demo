{merge}    = require './helpers.coffee'
{Indicator}  = require './indicator.coffee'

exports.Quantity = class Quantity

  defaults:
    value: 0
    indicator: [{type: "bar"}, {type: "digital"}]

  @create: (config, data) ->
    quantity = {}
    for qty_id, cfg of config
      quantity[qty_id] = new Quantity(qty_id, cfg, data)
    return quantity

  constructor: (@id, config, data) ->
    @config = merge @defaults, config
    @value = @config.value

    # console.log data


    @indicators = Indicator.create @config.indicator, @refine data,


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
    for indicator in @indicators
      indicator.update(@refine data)
