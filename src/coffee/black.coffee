import static_content from '../pug/document.pug'


require("expose-loader?$!jquery")

{Gauge} = require './gauge.coffee'



$ ->
  $('html').append static_content()  # < pug/document.pug

  gauge = new Gauge
    "T1": {
      title: "Eins"
      quantity:
        "main":   pointer: [{type: "bar"}, {type: "digital"}]
        "preset": pointer: [{type: "marker"}]

    }
    "T2": {title: "Zwei", quantity: "main": {} }
    "T3": {title: "Drei", quantity: "main": {} }
    "T4": {title: "Vier", quantity: "main": {} }

  # gauge.value "T1": {main: -22}
  # gauge.value "T2": {main: 44}
  # gauge.value "T3": {main: 66}, "T4": {main: 188}
