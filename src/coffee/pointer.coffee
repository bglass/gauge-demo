{merge}    = require './helpers.coffee'


exports.Pointer = class Pointer

  defaults: {}

  @create: (config) ->
    pointers = []
    for ptr_id, cfg of config
      pointers.push (new Pointer(ptr_id, cfg))
    return pointers

  constructor: (@id, config) ->
    @config = merge @defaults, config



      #
      #
      #
      # @config[id][qty] = value
      #
      #
      # data = @dynamic @config[id]
      # bar.setAttribute "d", data.path_bar
      #
      # text = $("#"+id).find(".digital")[0];
      # text.textContent = @label_digital(data)
      #
      # if data.r < 0.0
      #   vu = "visible"
      #   vo  = "hidden"
      # else if data.r > 1.0
      #   vu  = "hidden"
      #   vo = "visible"
      # else
      #   vo = "hidden"
      #   vu  = "hidden"
      #
      # $("#"+id).find(".underflow")[0].setAttribute "visibility", vu
      # $("#"+id).find(".overflow" )[0].setAttribute "visibility", vo


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

  update_pointer: (gauge_id, quantity, pointer) ->
    switch pointer.type
      when "bar"
        # $("svg#"+)
        path_bar(@config, quantity, pointer)
        pointer_bar(config, quantity, pointer)
      when "digital"
        svg_digital_display(config, quantity, pointer)
      else
        console.log "ERROR: pointer type #{pointer.type} is undefined."




    console.log quantity
    console.log pointer

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
