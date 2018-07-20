
exports.Drawing = class Drawing

  constructor: (@id, @width, @height) ->
    @content = "";

  get: ->
    xml "svg", @content,
      viewBox:    "0 0 #{@width} #{@height}"
      id:         @id

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

  text: (str, attributes) ->
    @content = @content + xml("text", str, attributes)

  path: (attributes) ->
    @content = @content + xml("path", "", attributes)

  polygon: (attributes) ->
    @content = @content + xml("polygon", "", attributes)

  attr_str = (attributes) ->
    attr = []
    for key, value of attributes
      attr.push "#{key}='#{value}'"
    return attr.join(" ")

  xml = (tag, content, attributes) ->
    return "<#{tag} #{attr_str attributes}>#{content}</#{tag}>"
