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
    quantities = []
    for qty_id, cfg of config
      quantities.push (new Quantity(qty_id, cfg))
    return quantities

  constructor: (@id, config) ->
    @config = merge @defaults, config
    @pointers = Pointer.create @config.pointers
    @value = @config.value

  relative_value = (cfg, quantity)->
    (@value - @config.v0) / (@config.v1 - @config.v0)

  value: (update) ->
    for id, data of update
      bar = $("svg#"+id).find(".bar")[0];
      bar.setAttribute("stroke", "#00ff00")


      for qty, value of data

        quantity = @config[id].quantity[qty]
        quantity.value = value

        for pointer in quantity.pointer
          @update_pointer(id, quantity, pointer)
