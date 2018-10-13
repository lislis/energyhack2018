var css = require('sheetify')
var choo = require('choo')

css('tachyons')

var app = choo()
if (process.env.NODE_ENV !== 'production') {
  app.use(require('choo-devtools')())
} else {
  app.use(require('choo-service-worker')())
}

app.use((state, emitter) => {
  state.providers = []

  emitter.on('DOMContentLoaded', () => {
    console.log('try fetch')
    window.fetch('http://localhost:3000/api/providers',
                 { mode: "cors",
                   headers: {
                     "Content-Type": "application/json; charset=utf-8"
                   }
                 })
    .then((res) => res.json())
    .then((data) => {
      console.log(data)
      state.providers = state.providers.concat(data.data.providers) 
      emitter.emit('render')
    })
     .catch((err) => {
       emitter.emit('error', err)
     })
  })

})

app.route('/', require('./views/main'))
app.route('/provider/:provider', require('./views/show'))
//app.route('/:provider/board', require('./views/board'))
app.route('/*', require('./views/404'))

module.exports = app.mount('body')
