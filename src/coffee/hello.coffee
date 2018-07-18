import content from '../pug/index.pug'
require("expose-loader?$!jquery");


$ ->
  $('body').append content()
