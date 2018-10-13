var html = require('choo/html')
var provider = require('./provider.js')

var TITLE = 'energyhack2018 - main'

module.exports = view

function view (state, emit) {
  if (state.title !== TITLE) emit(state.events.DOMTITLECHANGE, TITLE)
  //debugger
  return html`
    <body class="">
      <h1>Kontakt mit Versorgern</h1>
      <div>
       ${state.providers.map(providerMap)}
      </div>
    </body>
  `

  function providerMap(obj, i) {
    var providers = state.providers
    return provider(obj, i)
  }
}
