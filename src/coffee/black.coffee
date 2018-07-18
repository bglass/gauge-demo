import static_content from '../pug/document.pug'


require("expose-loader?$!jquery")

{Gauge} = require './gauge.coffee'



$ ->
  $('html').append static_content()  # < pug/document.pug

  gauge = new Gauge


  gauges = gauge.setup
    "#T1": "Eins",
    "#T2": "Zwei",
    "#T3": "Drei",
    "#T4": "Vier"
