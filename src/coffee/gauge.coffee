svg = require '../pug/svg.pug'

exports.Gauge = class Gauge
  constructor: ->

  setup: (config)->
    for id, item of config
      $(id).append svg
