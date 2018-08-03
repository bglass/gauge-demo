import main_tabs from '../pug/main_tabs.pug'


require("expose-loader?$!jquery")


{Tabs}  = require './tabs.coffee'

window.tab_select = Tabs.tab_select

$ ->

  $('body').append main_tabs()  # < pug/document.pug
  $("#btnBasic").click();
  $("#btnClocks").click();


  (require './basic.coffee').add()
  (require './clocks.coffee').add()
