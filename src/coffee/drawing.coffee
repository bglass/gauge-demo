
exports.Drawing = class Drawing

  constructor: (@id, @width, @height) ->
    @content = "";

  get: ->
    xml "svg", @content,
      viewBox:    "0 0 #{@width} #{@height}"
      id:         @id

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
