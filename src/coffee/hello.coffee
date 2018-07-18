import content from '../pug/index.pug'
require("expose-loader?$!jquery");


$ ->
  $('html').append content()
