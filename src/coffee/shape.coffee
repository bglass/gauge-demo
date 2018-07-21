{merge}        = require './helpers.coffee'


class Shape

  constructor: (@shape) ->

  shape: ->
    @shape

exports.Circle = class Circle extends Shape

  constructor: (radius) ->
    super "<circle cx=0 cy=0 r=#{radius} stroke='black' stroke-width=3 fill='black' />"
