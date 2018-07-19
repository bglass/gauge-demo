drawing = require '../pug/gauge.svg.pug'

tap = (o, fn) -> fn(o); o
merge = (xs...) ->
  if xs?.length > 0
    tap {}, (m) -> m[k] = v for k, v of x for x in xs


exports.Gauge = class Gauge

  constructor: (@config)->
    for id, config of @config
      @config[id] = merge @default, config
      for name, ptr_cfg of config.pointer
        @config[id].pointer[name] = merge @pointer_default, ptr_cfg
    @draw()

  default:
    title: ""
    pointer: {}
    unit: ""
    width: 1000
    height: 500
    barwidth: 100
    v0:  0
    v1:  100

  pointer_default:
    value: 0.0

  geometry: (cfg) ->
    cfg.x0 = cfg.width * .1
    cfg.x1 = cfg.width * .9
    cfg.path_backdrop = @path_backdrop(cfg)
    cfg.poly_triangle_left  = @poly_triangle_left(cfg)
    cfg.poly_triangle_right = @poly_triangle_right(cfg)

  pointer: (cfg, pointer)->
    r  = (cfg.pointer[pointer].value - cfg.v0) / (cfg.v1 - cfg.v0)
    x  = cfg.x0 + r * (cfg.x1 - cfg.x0)

    if r < 0.0
      x = cfg.x0
    else if r > 1.0
      x = cfg.x1

    data = {}
    data.r = r
    data.x = x
    data.path_bar      = @path_bar((merge cfg, data), pointer)
    return data


  draw: ->

    for id, cfg of @config
      @geometry @config[id]

      for pointer, pcfg of cfg.pointer
        data        = @pointer  @config[id], pointer
        $("#"+id).append drawing(merge cfg, data)

  # label_digital: (cfg) ->
  #   "#{cfg.value} #{cfg.unit}"

  # value: (update) ->
  #   for id, value of update
  #     bar = $("#"+id).find(".bar")[0];
  #     bar.setAttribute("stroke", "#00ff00")
  #
  #     @config[id].value = value
  #     data = @dynamic @config[id]
  #     bar.setAttribute "d", data.path_bar
  #
  #     text = $("#"+id).find(".digital")[0];
  #     text.textContent = @label_digital(data)
  #
  #     if data.r < 0.0
  #       vu = "visible"
  #       vo  = "hidden"
  #     else if data.r > 1.0
  #       vu  = "hidden"
  #       vo = "visible"
  #     else
  #       vo = "hidden"
  #       vu  = "hidden"
  #
  #     $("#"+id).find(".underflow")[0].setAttribute "visibility", vu
  #     $("#"+id).find(".overflow" )[0].setAttribute "visibility", vo


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


  # svg: (id) ->
  #   w = @config[id].width
  #   h = @config[id].height
  #   """
  #   <svg viewBox='0 0 #{w} #{h}' id='##{id}')>
  #   """
  #
  # svg_: "</svg>"
  #
  # backdrop: (cfg) ->
  #   """
  #   <path class='backdrop' d= #{cfg.path_backdrop}
  #         stroke-width='#{barwidth}' stroke='#bbbbbb' fill='none'
  #   </path>
  #   """
  #
  # bar: (data)
  #   """
  #   <path class="bar" d= #{cfg.path_bar}
  #       stroke-width=`${barwidth}` stroke="#0000ff" fill="none"
  #   </path>
  #   """

  # //- needle
  #
  # //- trend
  #
  # //- marker
  #
  # //- ticks

  # //- out of range
  # polygon(  class='underflow'
  #           points= poly_triangle_left
  #           fill="#0000ff" visibility="hidden"
  #         )
  # polygon(  class='overflow'
  #           points= poly_triangle_right
  #           fill="#0000ff" visibility="hidden"
  #         )
  #
  # //- digital display
  # text( class='digital'
  #       text-anchor="end"
  #       alignment-baseline="middle"
  #       x=`${width}` y=`${height*.8}`
  #       font-size="100"
  #       font-weight="bold" ) #{value} #{unit}
  #
  # //- label
  # text( class='title'
  #       text-anchor="start"
  #       alignment-baseline="middle"
  #       x=`${0}` y=`${height*.8}`
  #       font-size="100"
  #       font-weight="normal" )= title
  #
  #
