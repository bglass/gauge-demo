import main_grid      from '../pug/main_grid.pug'
import main_tabs      from '../pug/main_tabs.pug'


require("expose-loader?$!jquery")

{Gauge} = require './gauge.coffee'

{Tabs} = require './tabs.coffee'

window.tab_select = Tabs.tab_select

$ ->

  $('body').append main_tabs()  # < pug/document.pug
  $("#btnBasic").click();




  Gauge.create
    "T1":
      title: "Eins"
      scale:
        "S1":
          label: "Temperature"
          unit:  "K"
          type:  "horizontal"
          tickDivisions: 2
          quantity:
            "main":
              indicator: 
                "Bar":      type: "bar"
                "Digital":  type: "digital"
            "preset":
              indicator:
                "Mark1":
                  type:  "pointer"
                  shape: "left"
    "T2":
      title: "Zwei"
      scale:
        "S2":
          label: "Criticality"
          type:  "vertical"
          tickDivisions: 3
          quantity:
            "main":
              indicator: 
                "Bar2":      type: "bar"
                "Digital2":  type: "digital"
            # "preset":
            #   indicator:
            #     "X2": type: "pointer"
    "T3":
      title: "Drei"
      scale:
        "S3":
          label: "Temperature"
          type:  "circular_arc"
          tickDivisions: 5
          quantity:
            "main":
              indicator: 
                "Bar3":
                  type: "bar"
                  color: "#ffe78d"
                "Digital3":  type: "digital"
            "prea":
              indicator:
                "Mark3a":
                  type:  "pointer"
                  shape: "left"
                  color: "red"
            "preb":
              indicator:
                "Mark3b":
                  type:  "pointer"
                  shape: "needle1"
                  digit_dy: 900
                  color: "black"
            "prec":
              indicator:
                "Mark3c":
                  type:  "pointer"
                  shape: "right"
                  digit_dy: 155
                  color: "blue"
    "T4":
      title: "Vier"
      scale:
        "S4":
          label: "Temperature"
          type:  "horizontal"
          tickDivisions: 10
          quantity:
            "main":
              indicator: 
                "Bar4":      type: "bar"
                "Digital4":  type: "digital"
            # "preset":
            #   indicator:
            #     "X4": type: "pointer"






  Gauge.setValue "T1": {main: 12}
  Gauge.setValue "T2": {main: 55}
  Gauge.setValue "T3": {main: 25}, "T4": {main: 27}

  Gauge.setValue "T1": {preset: 20}
  Gauge.setValue "T3": {prea: 15}
  Gauge.setValue "T3": {preb: 20}
  Gauge.setValue "T3": {prec: 25}
