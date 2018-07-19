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

  geometry: (cfg) ->
    cfg.x0 = cfg.width * .1
    cfg.x1 = cfg.width * .9
    cfg.path_backdrop = @path_backdrop(cfg)
    cfg.poly_triangle_left  = @poly_triangle_left(cfg)
    cfg.poly_triangle_right = @poly_triangle_right(cfg)
    return cfg

  dynamic: (cfg)->
    r  = (cfg.value - cfg.v0) / (cfg.v1 - cfg.v0)
    x  = cfg.x0 + r * (cfg.x1 - cfg.x0)

    if r < 0.0
      x = cfg.x0
    else if r > 1.0
      x = cfg.x1

    cfg.r = r
    cfg.x = x
    cfg.path_bar      = @path_bar(cfg)

    return cfg


  draw: ->

    for id, cfg of @config
      @config[id] = @geometry @config[id]
      data        = @dynamic  @config[id]

      $("#"+id).append drawing(data)

  label_digital: (cfg) ->
    "#{cfg.value} #{cfg.unit}"

  value: (update) ->
    for id, value of update
      bar = $("#"+id).find(".bar")[0];
      bar.setAttribute("stroke", "#00ff00")

      @config[id].value = value
      data = @dynamic @config[id]
      bar.setAttribute "d", data.path_bar

      text = $("#"+id).find(".digital")[0];
      text.textContent = @label_digital(data)

      if data.r < 0.0
        vu = "visible"
        vo  = "hidden"
      else if data.r > 1.0
        vu  = "hidden"
        vo = "visible"
      else
        vo = "hidden"
        vu  = "hidden"

      $("#"+id).find(".underflow")[0].setAttribute "visibility", vu
      $("#"+id).find(".overflow" )[0].setAttribute "visibility", vo


# drawing elements

  path_bar: (cfg) ->
    "M #{cfg.x0} #{cfg.height/2} " +
    "L #{cfg.x} #{cfg.height/2}"

  path_backdrop: (cfg) ->
    "M #{cfg.x0} #{cfg.height/2} " +
    "L #{cfg.x1} #{cfg.height/2}"

  poly_triangle_left: (cfg) ->
    y  = cfg.height/2
    dx = dy = cfg.barwidth/2

    "0 #{y} " +
    "#{dx} #{y - dy} " +
    "#{dx} #{y + dy}"

  poly_triangle_right: (cfg) ->
    y  = cfg.height/2
    dx = dy = cfg.barwidth/2
    w  = cfg.width

    "#{w     } #{y} " +
    "#{w - dx} #{y - dy} " +
    "#{w - dx} #{y + dy}"
