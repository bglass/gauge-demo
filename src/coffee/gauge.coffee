drawing = require '../pug/gauge.svg.pug'

tap = (o, fn) -> fn(o); o
merge = (xs...) ->
  if xs?.length > 0
    tap {}, (m) -> m[k] = v for k, v of x for x in xs


exports.Gauge = class Gauge

  constructor: (@config)->
    for id, config of @config
      @config[id] = merge @default, config
    @draw()

  default:
    title: "Lina"
    value: "-273.1"
    unit: "°C"
    width: 1000
    height: 500
    barwidth: 100
    v0:  0
    v1:  100
    value: 42
    id: "T08"

  geometry: (config) ->
    config.x0 = config.width * .1
    config.x1 = config.width * .9
    return config

  dynamic: (config)->
    r  = (config.value - config.v0) / (config.v1 - config.v0)
    x  = config.x0 + r * (config.x1 - config.x0)

    if r < 0.0
      x = config.x0
    else if r > 1.0
      x = x1

    config.r = r
    config.x = x
    return config


  draw: ->

    for id, config of @config
      @config[id] = @geometry @config[id]
      data        = @dynamic  @config[id]

      $("#"+id).append drawing(data)

  path_bar: (value) ->
    "M #{@x0} #{height/2} L #{x} #{height/2}"

  value: (data) ->
    for id, value of data
      svg = $('#T08').find(".bar")[0];
      svg.setAttribute("stroke", "#00ff00")
