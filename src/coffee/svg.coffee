{merge}    = require './helpers.coffee'


exports.SVG = class SVG

  constructor: (@id, @node)->
    @me = "SVG"

  @add_svg: (id, xywh) ->
    $("div#" + id).append(
      xml "svg", "",
        viewBox:    xywh.join(" ")
        id:         id
    )
    svg = new SVG(id, $("svg#"+id)[0])
    svg.defs = svg.add_defs()
    return svg


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

  add_group: (id, attributes = {}) ->
    @add_element id, "g", attributes

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

      else
        @add_polygon id, merge
          points: polygon(shape, 100)
          attributes







  polygon = (shape, size) ->
    scale_polygon size/10.0,
      switch shape
        when "right"
          [ 0,0,  5, 10,  -5, 10]
        when "left"
          [ 0,0,  5,-10,  -5,-10]
        when "needle1"
          [ 0,-10,  2,0, 5,80, 0,85, -5,80, -2,0 ]


  scale_polygon = (size, data) ->
    data.map (number) -> size*number

  add_defs: ->
    @add_element "defs", "defs", {}

  add_marker: (id, attributes) ->
    @add_element id, "marker", attributes


  follow_path: (target) ->
    motion = @add_element "motion"+@id, "animateMotion",
      begin:            "indefinite"
      rotate:           "auto"
      dur:              "5s"
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

  # modulate_color: (target_attribute) ->
  #   @add_element "acol"+@id, "animate",
  #     attributeName:  target_attribute
  #     attributeType:  "XML"
  #     dur:            ".5s"
  #     fill:           "freeze"



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
      when "horseshoe"
        horseshoe cfg

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
    r  = data.w*.6
    mx = data.w*.9;       my = data.h*.9
    sx = mx-r;            sy = my

    "M #{sx} #{sy} a #{r} #{r} 0 0 1 #{r} #{-r}"


  horseshoe = (data) ->
    r  = data.w*.3
    sx = data.w*.3;            sy = data.h*.7
    ex = data.w*.7;            ey = data.h*.7


    "M #{sx} #{sy} A #{r} #{r} 0 1 1 #{ex} #{ey}"





  offset: (distance, crosstrack) ->
    t  = distance
    c  = crosstrack

    arccos  = Math.acos
    pi      = Math.PI
    l  = @node.getTotalLength()
    dt = 1e-2

    if t >   dt   then t0 = t-dt else t0 = t
    if t < (1-dt) then t1 = t+dt else t1 = t

    p  = @node.getPointAtLength t  * l
    p0 = @node.getPointAtLength t0 * l
    p1 = @node.getPointAtLength t1 * l

    dx = p1.x - p0.x
    dy = p1.y - p0.y

    r   = Math.sqrt( dx*dx + dy*dy )

    phi = if dy<0
            -arccos dx/r
          else
            arccos dx/r

    tx = dx/r
    ty = dy/r

    nx = -ty
    ny =  tx

    ox = p.x + c * nx
    oy = p.y + c * ny

    {x: ox, y: oy, phi: 180*phi/pi}






# =============================================================================
