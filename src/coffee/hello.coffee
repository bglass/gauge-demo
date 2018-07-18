import content from '../pug/index.pug'



component = ->
  element = document.createElement('div')

  element.innerHTML = content()
  return element

document.body.appendChild component()
