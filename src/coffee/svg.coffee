{merge}    = require './helpers.coffee'


exports.SVG = class SVG

  constructor: (@id, @node)->
    @me = "SVG"

  @add_viewbox: (id, xywh) ->
    $("div#" + id).append(
      xml "svg", "",
        viewBox:    xywh.join(" ")
        id:         id
    )
    svg = new SVG(id, $("svg#"+id)[0])

  ns = "http://www.w3.org/2000/svg"

  add_element: (id, type, attributes) ->
    @new_tag id, type, attributes
    new SVG(id, $("svg #{type}##{id}")[0])

  new_tag: (id, type, attributes) ->
    # console.log id, type, attributes
    tag = document.createElementNS(ns, type)
    tag.setAttribute "id", id
    for key, value of attributes
      tag.setAttribute key, value
    @node.appendChild(tag)


  add_text: (id, content, attributes) ->
    svg = @add_element id, "text", attributes
    svg.node.textContent = content
    return svg

  add_path: (id, shape, attributes) ->
    @new_tag id, "path", attributes
    svg = new Path(id, $("svg > path##{id}")[0])
    svg.node.setAttribute "d", shape
    svg.node.setAttribute "pathLength", 1.0
    svg.node.setAttribute "fill", "none"
    svg.shape = shape
    return svg

  derive_path: (id, template, attributes) ->
    @add_path id, template.shape, attributes

  new_path: (id, config, attributes) ->
    @add_path id, (Path.shape config), attributes

  add_polygon: (id, attributes) ->
    @add_element id, "polygon", attributes

  add_shape: (id, shape, attributes) ->
    switch shape
      when "circle"
        @add_element id, shape, attributes
      when "left"
        @add_polygon id, merge
          points: triangle_left(100),
          attributes
      when "right"
        @add_polygon id, merge
          points: triangle_right(100),
          attributes

  triangle_right = (size) ->
    s1 = size; s2 = size/2
    [ 0, 0,   s2, s1,   -s2, s1 ].join(" ")

  triangle_left = (size) ->
    s1 = size; s2 = size/2
    [ 0, 0,   s2, -s1,   -s2, -s1 ].join(" ")


  add_defs: (id) ->
    @add_element id, "defs", {}

  add_marker: (id, attributes) ->
    @add_element id, "marker", attributes


  follow_path: (target) ->
    motion = @add_element "motion"+@id, "animateMotion",
      rotate:           "auto"
      dur:              ".5s"
      keyTimes:         "0;1"
      keyPoints:        "0;0"
      calcMode:         "linear"
      fill:             "freeze"
      path:             target.shape
    return motion

  attr_str = (attributes) ->
    attr = []
    for key, value of attributes
      attr.push "#{key}='#{value}'"
    return attr.join(" ")

  xml = (tag, content, attributes) ->
    return "<#{tag} #{attr_str attributes}>#{content}</#{tag}>"

  update: (attributes) ->
    for key, value of attributes
      @node.setAttribute key, value




# =============================================================================

class Path extends SVG

  position: (distance) ->
    @node.getPointAtLength distance * @node.getTotalLength()

  @shape: (cfg) ->
    switch cfg.type
      when "horizontal"
        horizontal cfg
      when "vertical"
        vertical cfg
      when "circular_arc"
        circular_arc cfg

  horizontal = (data) ->
    x0 = data.w * .1
    x1 = data.w * .9
    y  = data.h / 2
    "M #{x0} #{y} L #{x1} #{y}"

  vertical = (data) ->
    y0 = data.h * .1
    y1 = data.h * .9
    x  = data.w / 2
    "M #{x} #{y1} V #{y0}"


  circular_arc = (data) ->
    r  = data.w*.8
    mx = data.w*.9;       my = data.h*.9
    sx = mx-r;            sy = my

    "M #{sx} #{sy} a #{r} #{r} 0 0 1 #{r} #{-r}"





# =============================================================================
