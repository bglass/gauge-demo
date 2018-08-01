{SVG}           = require './svg.coffee'

exports.events = (gauge, svg) ->

  node     = svg.node
  element  = false
  quantity = false
  path     = false

  startDrag = (evt) ->
    if evt.target.classList.contains('draggable')
      element  = evt.target
      quantity = element.dataset.quantity
      path     = SVG.store[element.dataset.path]

  endDrag = (evt) ->
    element = false

  drag = (evt) =>
    if element
      evt.preventDefault()
      # console.log gauge.id
      rl0     = gauge.getRelativeLimited quantity
      coords  = getMousePosition evt
      t       = path.project rl0, coords
      gauge.setRelative quantity, t

  wheel = (evt) =>
    if evt.target.classList.contains('draggable')
      if evt.wheelDelta > 0
        gauge.stepValue quantity, "up"
      else
        gauge.stepValue quantity, "down"

  click = (evt) =>
    console.log evt

  getMousePosition = (evt) =>
    CTM = node.getScreenCTM()
    return {
      x: (evt.clientX - CTM.e) / CTM.a,
      y: (evt.clientY - CTM.f) / CTM.d
    }

  node.addEventListener('mousedown',  startDrag)
  node.addEventListener('mousemove',  drag)
  node.addEventListener('mouseup',    endDrag)
  node.addEventListener('mouseleave', endDrag)
  node.addEventListener("wheel",      wheel, {passive: true})
  node.addEventListener("click",      click)
