{Gauge} = require '../../src/coffee/gauge.coffee'

exports.add = ->
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
          "Dawn":
            indicator: "dawn":
              type:    "bar"
              color:   "grey"
              width:   40
          "Dusk":
            indicator: "dusk":
              type:    "bar"
              invert:  true
              color:   "grey"
              width:   40
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

  Gauge.setValue
    "C2": {Dawn: 5}

  Gauge.setValue
    "C2": {Dusk: 20}
