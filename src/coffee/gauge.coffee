backdrop = require '../pug/backdrop.svg.pug'


exports.Gauge = class Gauge
  constructor: ->

  title: "Hallo"


  setup: (config)->
    for id, name of config
      @backdrop id, name

  backdrop: (id, name) ->
    $(id).append backdrop({title: "Lina", value: "-237.1", unit: "C"})


  update: (data) ->
    for id, value of data
      x = value
