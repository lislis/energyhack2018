var html = require('choo/html')
var provider = require('./provider.js')

var TITLE = 'energyhack2018 - show'

module.exports = view

function view (state, emit) {
  if (state.title !== TITLE) emit(state.events.DOMTITLECHANGE, TITLE)

  var slug = state.params.provider
  
  return html`
    <body class="">
      <h1>${slug}</h1>
      <div>
       ${state.providers.map(providerMap)}
      </div>
    </body>
  `

  function providerMap(obj, i) {
    var slug = state.params.provider

    if (obj.slug !== slug) {
      return
    } else {
      return provider(obj, i)
    }
  }
}
