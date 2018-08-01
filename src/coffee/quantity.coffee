{merge}       = require './helpers.coffee'
{Indicator}   = require './indicator.coffee'
{settings}    = require './presets.coffee'

exports.Quantity = class Quantity


  @create: (config, data) ->
    quantity = {}

    for qty_id, cfg of config
      quantity[qty_id] = new Quantity(qty_id, cfg, data)
    return quantity

  constructor: (@id, config, data) ->
    @config = settings("quantity", config)
    @value = @config.value

    @indicators = Indicator.create @config.indicator, @refine data,

  refine: (data) ->
    merge data,
      a:      @value
      r:      @relative_value(data)
      rl:     @limited_value(data)
      qId:    @id

  relative_value: (data) ->
    v0 = data.v0 * @config.scale_factor
    v1 = data.v1 * @config.scale_factor
    (@value - v0) / (v1 - v0)

  limited_value: (data)->
    r = @relative_value(data)
    if r < 0.0
      return 0.0
    else if r > 1.0
      return 1.0
    else
      return r


  setValue: (data, value) ->
    @value = parseFloat(value)
    for indicator in @indicators
      indicator.update(@refine data)

  setRelative: (data, r) ->
    v0 = data.v0 * @config.scale_factor
    v1 = data.v1 * @config.scale_factor
    @setValue data, parseFloat(r) * (v1-v0) + v0

  stepValue: (data, direction) ->
    va = Math.round( @value/@config.stepIncrement ) * @config.stepIncrement
    vb =  if direction == "up"
            va + @config.stepIncrement
          else
            va - @config.stepIncrement

    vc = vb
    
    if data.cyclic
      if vb > data.v1
        vc = vb - (data.v1-data.v0)
      else if vb < data.v0
        vc = vb + (data.v1-data.v0)

    @setValue(data, vc)
