import main_grid      from '../pug/main_grid.pug'


require("expose-loader?$!jquery")

{Gauge} = require './gauge.coffee'



$ ->
  $('body').append main_grid()  # < pug/document.pug

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
              pointer: 
                "Bar":      type: "bar"
                "Digital":  type: "digital"
            "preset":
              pointer:
                "Mark1":
                  type:  "marker"
                  shape: "circle"
    "T2":
      title: "Zwei"
      scale:
        "S2":
          label: "Criticality"
          type:  "vertical"
          tickDivisions: 3
          quantity:
            "main":
              pointer: 
                "Bar2":      type: "bar"
                "Digital2":  type: "digital"
            # "preset":
            #   pointer:
            #     "X2": type: "marker"
    "T3":
      title: "Drei"
      scale:
        "S3":
          label: "Temperature"
          type:  "circular_arc"
          tickDivisions: 5
          quantity:
            "main":
              pointer: 
                "Bar3":      type: "bar"
                "Digital3":  type: "digital"
            "preset":
              pointer:
                "Mark3":
                  type:  "marker"
                  shape: "circle"
    "T4":
      title: "Vier"
      scale:
        "S4":
          label: "Temperature"
          type:  "horizontal"
          tickDivisions: 10
          quantity:
            "main":
              pointer: 
                "Bar4":      type: "bar"
                "Digital4":  type: "digital"
            # "preset":
            #   pointer:
            #     "X4": type: "marker"






  Gauge.setValue "T1": {main: -22}
  Gauge.setValue "T1": {preset: 20}
  Gauge.setValue "T3": {preset: 20}

  Gauge.setValue "T2": {main: 15}
  Gauge.setValue "T3": {main: 25}, "T4": {main: 188}
