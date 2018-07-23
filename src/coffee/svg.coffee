exports.SVG = class SVG

  constructor: (@id, @node)->

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
    new SVG(id, $("svg > #{type}##{id}")[0])

  new_tag: (id, type, attributes) ->
    tag = document.createElementNS(ns, type)
    tag.setAttribute "id", id
    for key, value of attributes
      tag.setAttribute key, value
    @node.appendChild(tag)


  add_text: (id, content, attributes) ->
    svg = @add_element id, "text", attributes
    svg.node.textContent = content
    return svg

  add_path: (id, path, attributes) ->
    @new_tag id, "path", attributes
    svg = new Path(id, $("svg > path##{id}")[0])
    svg.node.setAttribute "d", path.shape
    return svg

  add_polygon: (id, attributes) ->
    @add_element id, "polygon", attributes

  add_shape: (id, shape, attributes) ->
    switch shape
      when "circle"
        @add_element id, shape, attributes

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


class Path extends SVG

  path_length: ->
    @node.getTotalLength()

  position: (distance) ->
    @node.getPointAtLength(distance)
