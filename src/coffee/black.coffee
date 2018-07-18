import content from '../pug/document.pug'
require("expose-loader?$!jquery");


$ ->
  $('html').append content()
