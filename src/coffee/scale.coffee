{merge}    = require './helpers.coffee'
{Quantity} = require './quantity.coffee'

exports.Scale = class Scale

  defaults:
    unit: "K"
    v0:  0
    v1:  100

  @create: (config, data0) ->
    scale = {}
    for scale_id, cfg of config
      scale[scale_id] = new Scale(scale_id, cfg, data0)
    return scale

  constructor: (@id, config, data0) ->
    @config = merge @defaults, config
    @value = @config.value
    @quantities = Quantity.create @config.quantity, (merge data0, @data())

  setValue: (update) ->
    for qty, value of update
      @quantities[qty].setValue @data(), value

  view: (data) ->
    for qty_id, quantity of @quantities
      quantity.view(merge data, @data())

  init: (data) ->
    for qty_id, quantity of @quantities
      quantity.init(merge data, @data())

  data: ->
    unit: @config.unit
    v0:   @config.v0
    v1:   @config.v1
