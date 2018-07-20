tap = (o, fn) -> fn(o); o
merge = (xs...) ->
  if xs?.length > 0
    tap {}, (m) -> m[k] = v for k, v of x for x in xs


exports.Gauge = class Gauge

  default:
    title: ""
    pointer: {}
    width: 1000
    height: 500
    v0:  0
    v1:  100

  quantity_default:
    barwidth: 100
    value: 77.0
    unit: "K"
    pointer: [{type: "bar"}, {type: "digital"}]

  constructor: (config)->
    @config = @setup(config)
    @draw_gauges(@config)

  setup: (user_config) ->
    setup = {}

    # merge user config into defaults
    for gauge_id, cfg of user_config
      setup[gauge_id] = merge @default, cfg
      for quantity_id, quantity_cfg of setup[gauge_id].quantity
        setup[gauge_id].quantity[quantity_id] = merge @quantity_default, quantity_cfg

    # calculate static geometry
      # cfg.path_backdrop = @path_backdrop(cfg)
      # cfg.poly_triangle_left  = @poly_triangle_left(cfg)
      # cfg.poly_triangle_right = @poly_triangle_right(cfg)

    return setup



  draw_gauges: (config) ->
    for gauge_id, gauge_config of config
      # console.log  @drawing(gauge_id, gauge_config)
      $("div#"+gauge_id).append @drawing(gauge_id, gauge_config)


  drawing: (id, data) ->

    elements = [
      svg_label(data)
    ]

    for quantity_id, quantity_config of data.quantity
      for pointer in quantity_config.pointer
        elements.push svg_pointer(data, quantity_config, pointer)
    # console.log elements

    return svg_viewbox id, data, elements.join("")




      # @geometry @config[id]
      # $("#"+id).append    (require '../pug/gauge.svg.pug')(cfg)
      #



  relative_value = (cfg, quantity)->
    (quantity.value - cfg.v0) / (cfg.v1 - cfg.v0)



      # console.log svg
      # for quantity, pcfg of cfg.quantity
      #   data        = @quantity  @config[id], quantity

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

  # path_bar: (cfg) ->
  #   "M #{cfg.x0} #{cfg.height/2} " +
  #   "L #{cfg.x} #{cfg.height/2}"

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



  # backdrop: (cfg) ->
  #   """
  #   <path class='backdrop' d= #{cfg.path_backdrop}
  #         stroke-width='#{barwidth}' stroke='#bbbbbb' fill='none'
  #   </path>
  #   """
  #


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

  svg_pointer = (config, quantity, pointer) ->
    switch pointer.type
      when "bar"
        pointer_bar(config, quantity, pointer)
      when "digital"
        svg_digital_display(config, quantity, pointer)
      else
        console.log "ERROR: pointer type #{pointer.type} is undefined."
        return ""

  pointer_bar = (cfg, quantity, pointer) ->

    defaults = barwidth: cfg.width/10

    pointer = merge defaults, pointer


    x0 = cfg.width * .1
    x1 = cfg.width * .9

    r = relative_value(cfg, quantity)
    x = x0 + (x1 - x0) * r

    if r < 0.0
      x = x0
    else if r > 1.0
      x = x1

    quantity.x  = x
    quantity.x0 = x0
    quantity.x1 = x1


    bar = xml "path", "",
      class:            "bar"
      d:                "#{path_bar(cfg, quantity, pointer)}"
      "stroke-width":   "#{pointer.barwidth}"
      stroke:           "#0000ff"
      fill:             "none"


    data_track = merge quantity, {x: x1}

    track = xml "path", "",
      class:            "bar_track"
      d:                "#{path_bar(cfg, data_track, "track")}"
      "stroke-width":   "#{pointer.barwidth}"
      stroke:           "#aaaaaa"
      fill:             "none"

    return track + bar


  path_bar = (cfg, quantity, pointer) ->
    # console.log quantity
    "M #{quantity.x0} #{cfg.height/2} " +
    "L #{quantity.x}  #{cfg.height/2}"


  svg_viewbox = (id, data, content) ->
    xml "svg", content,
      viewBox:    "0 0 #{data.width} #{data.height}"
      id:         id

  svg_digital_display = (data, quantity, pointer) ->
    xml "text",
      quantity.value + " " + quantity.unit,
      class:                "digital"
      "text-anchor":        "end"
      "alignment-baseline": "middle"
      x:                    "#{data.width}"
      y:                    "#{data.height*.8}"
      "font-size":          100
      "font-weight":        "bold"

  svg_label = (data) ->
    xml("text", data.title, {
      class:                "title"
      "text-anchor":        "start"
      "alignment-baseline": "middle"
      x:                    0
      y:                    "#{data.height*.8}"
      "font-size":          100
      "font-weight":        "normal"
    })

  attr_str = (attributes) ->
    attr = []
    for key, value of attributes
      attr.push "#{key}='#{value}'"
    return attr.join(" ")

  xml = (tag, content, attributes) ->
    return "<#{tag} #{attr_str attributes}>#{content}</#{tag}>"
