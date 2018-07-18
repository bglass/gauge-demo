svg = require '../svg/backdrop.svg'

exports.Gauge = class Gauge
  constructor: ->

  setup: (config)->
    for id, item of config
      $(id).append svg
