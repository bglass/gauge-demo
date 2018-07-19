import static_content from '../pug/document.pug'


require("expose-loader?$!jquery")

{Gauge} = require './gauge.coffee'



$ ->
  $('html').append static_content()  # < pug/document.pug

  gauge = new Gauge
    "T1": {
      title: "Eins"
      pointer:
        main:   type: "bar"
        preset: type: "marker"
    }
    # "T2": {title: "Zwei"}
    # "T3": {title: "Drei"}
    # "T4": {title: "Vier"}

  # gauge.value "T1": {main: -22}
  # gauge.value "T2": {main: 44}
  # gauge.value "T3": {main: 66}, "T4": {main: 188}
