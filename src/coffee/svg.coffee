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
    tag = document.createElementNS(ns, type)
    tag.setAttribute "id", id
    for key, value of attributes
      tag.setAttribute key, value
    @node.appendChild(tag)
    new SVG(id, $("svg > #{type}##{id}")[0])

  add_text: (id, content, attributes) ->
    svg = @add_element id, "text", attributes
    svg.node.textContent = content
    return svg

  add_path: (id, path, attributes) ->
    svg = @add_element id, "path", attributes
    svg.node.setAttribute "d", path.shape
    return svg

  add_polygon: (id, attributes) ->
    @add_element id, "polygon", attributes



  attr_str = (attributes) ->
    attr = []
    for key, value of attributes
      attr.push "#{key}='#{value}'"
    return attr.join(" ")

  xml = (tag, content, attributes) ->
    return "<#{tag} #{attr_str attributes}>#{content}</#{tag}>"

  path_length: ->
    @node.getTotalLength()
