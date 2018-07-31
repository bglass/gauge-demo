import main_tabs      from '../pug/main_tabs.pug'


require("expose-loader?$!jquery")

{Gauge} = require '../../src/coffee/gauge.coffee'

{Tabs} = require './tabs.coffee'

window.tab_select = Tabs.tab_select

$ ->

  $('body').append main_tabs()  # < pug/document.pug
  $("#btnClocks").click();



  Gauge.create
    "T1":
      title:    "Horizontal"
      scale:    "S1":
        type:     "horizontal"
        presets:   ["Room_Temperature", "Ticks_Left"]
        quantity: "T":
          indicator:
            "Bar":      type: "bar"
            "Digital":  type: "digital"
    "T2":
      title:    "Vertical"
      scale:    "S1":
        type:     "vertical"
        presets:   ["Room_Temperature", "Ticks_Right"]
        number:
          rotate: -30
        quantity: "T":
          indicator:
            "Bar":      type: "bar"
            "Digital":  type: "digital"


  Gauge.create
    "C1":
      title:    ""
      scale:    "clk":
        presets:   ["Ticks_Left", "Clock"]
        number:
          v0:         2
          v1:         12
          divisions:  5
          offset:     20
          rotate:      0
        quantity:
          "H":
            indicator: "hours":
              type:       "pointer"
              shape:      "line"
              dimension:  [120, 320]
              thickness:  30
          "M":
            scale_factor: 5
            indicator: "minutes":
              type:       "pointer"
              shape:      "line"
              dimension:  [70, 330]
              thickness:  20
          "S":
            scale_factor: 5
            indicator: "seconds":
              type:       "pointer"
              shape:      "line"
              dimension:  [-40, 360]
              thickness:  5
              color:      "red"
              speed:      .15

  Gauge.create
    "C2":
      title:    ""
      scale:    "clk":
        presets:   ["Clock"]
        v1:     24
        number:
          v0:         0
          v1:         22
          divisions:  11
          offset:     -150
          rotate:      0
        tick:
          offset1:      -60
          offset2:      -100
          v1:           24
          divisions:    24
        subtick:
          offset1:      -50
          offset2:      -30
          v1:           24
          divisions:    60
        quantity:
          "H":
            indicator: "hours":
              type:       "pointer"
              shape:      "line"
              dimension:  [120, 320]
              thickness:  30
          "M":
            scale_factor: 2.5
            indicator: "minutes":
              type:       "pointer"
              shape:      "line"
              dimension:  [70, 330]
              thickness:  20
          "S":
            scale_factor: 2.5
            indicator: "seconds":
              type:       "pointer"
              shape:      "line"
              dimension:  [-40, 360]
              thickness:  5
              color:      "red"
              speed:      .15





  tick = ->
    time = new Date

    x = time.getMilliseconds()
    x = Math.round(x/250)*250
    s = time.getSeconds() + x/1000
    m = time.getMinutes() + s/60
    h12 = time.getHours() %% 12 + m/60
    h24 = time.getHours()       + m/60

    Gauge.setValue
      "C1": {H: h12 }
      "C2": {H: h24 }

    Gauge.setValue
      "C1": {M: m}
      "C2": {M: m}

    Gauge.setValue
      "C1": {S: s}
      "C2": {S: s}

  setInterval tick, 500




  #     title:    "Demo 1"
  #     scale:
  #       "S1":
  #         label: "Temperature"
  #         unit:  "K"
  #         type:  "horizontal"
  #         tickDivisions: 2
  #         quantity:
  #           "main":
  #             indicator: 
  #               "Bar":      type: "bar"
  #               "Digital":  type: "digital"
  #           "preset":
  #             indicator:
  #               "Mark1":
  #                 type:  "pointer"
  #                 shape: "left"
  #   "T2":
  #     title: "Zwei"
  #     scale:
  #       "S2":
  #         label: "Criticality"
  #         type:  "vertical"
  #         tickDivisions: 3
  #         quantity:
  #           "main":
  #             indicator: 
  #               "Bar2":      type: "bar"
  #               "Digital2":  type: "digital"
  #           # "preset":
  #           #   indicator:
  #           #     "X2": type: "pointer"
  #   "T3":
  #     title: "Drei"
  #     scale:
  #       "S3":
  #         label: "Temperature"
  #         type:  "circular_arc"
  #         tickDivisions: 5
  #         track:
  #           color:          "lightgrey"
  #           segments: ["blue 0 15", "green 18 22", "red 25 30"]
  #         quantity:
  #           "main":
  #             indicator: 
  #               "Mark3b":
  #                 type:  "pointer"
  #                 shape: "needle1"
  #                 digit_dy: 900
  #                 color: "black"
  #               "Digital3":  type: "digital"
  #           "prea":
  #             indicator:
  #               "Mark3a":
  #                 type:  "pointer"
  #                 shape: "left"
  #                 color: "red"
  #           "preb":
  #             indicator:
  #               "Color3b":
  #                 type:       "color"
  #                 target:     "Mark3b"
  #                 attribute:  "fill"
  #           "prec":
  #             indicator:
  #               "Mark3c":
  #                 type:  "pointer"
  #                 shape: "right"
  #                 digit_dy: 155
  #                 color: "blue"
  #   "T4":
  #     title: "Vier"
  #     scale:
  #       "S4":
  #         label: "Temperature"
  #         type:  "horseshoe"
  #         tickDivisions: 10
  #         quantity:
  #           "main":
  #             indicator: 
  #               "Bar4":      type: "bar"
  #               "Digital4":  type: "digital"
  #               "Color4":
  #                 type:       "color"
  #                 target:     "Bar4"
  #                 attribute:  "stroke"
  #
  #           # "preset":
  #           #   indicator:
  #           #     "X4": type: "pointer"
  #
  #
  #
  #
  #
  #
  # Gauge.setValue "T1": {T: 12}
  # Gauge.setValue "T2": {T: 55}
  # Gauge.setValue "T3": {main: 25}, "T4": {main: 27}
  #
  # Gauge.setValue "T1": {preset: 20}
  # Gauge.setValue "T3": {prea: 15}
  # Gauge.setValue "T3": {preb: 20}
  # Gauge.setValue "T3": {prec: 25}
  #
  # $("input#main")[0].oninput = (event) ->
  #   Gauge.setValue "T1": {T: event.currentTarget.value}
  #   Gauge.setValue "T2": {T: event.currentTarget.value}
  #   Gauge.setValue "T3": {main: event.currentTarget.value}
  #   Gauge.setValue "T3": {preb: event.currentTarget.value}
  #   Gauge.setValue "T4": {main: event.currentTarget.value}
  #
  # $("input#pre1")[0].oninput = (event) ->
  #   Gauge.setValue "T1": {preset: event.currentTarget.value}
  #   Gauge.setValue "T3": {prea:   event.currentTarget.value}
  #
  # $("input#pre2")[0].oninput = (event) ->
  #   Gauge.setValue "T3": {prec:   event.currentTarget.value}
