component = ->
  element = document.createElement('div')
  # Lodash, currently included via a script, is required for this line to work
  element.innerHTML = _.join([
    'Hello'
    'webpack'
    'Do you want coffee?'
  ], ' ')
  element

document.body.appendChild component()
