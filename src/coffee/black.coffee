import static_content from '../pug/document.pug'


require("expose-loader?$!jquery")

{Gauge} = require './gauge.coffee'



$ ->
  $('html').append static_content()  # < pug/document.pug

  Gauge.create
    "T1": {
      title: "Eins"
      quantity:
        "main":   pointer: [{type: "bar"}, {type: "digital"}]
        "preset": pointer: [{type: "marker"}]

    }
    "T2": {title: "Zwei", quantity: "main": {} }
    "T3": {title: "Drei", quantity: "main": {} }
    "T4": {title: "Vier", quantity: "main": {} }

  Gauge.setValue "T1": {main: -22}
  Gauge.setValue "T2": {main: 44}
  Gauge.setValue "T3": {main: 66}, "T4": {main: 188}
