module.exports = store

function store (state, emitter) {
  state.offers = []

  emitter.on('DOMContentLoaded', function () {
    window.fetch(`http://localhost:3000/api/providers/${slug}/offers`,
               { mode: "cors",
                 headers: {
                   "Content-Type": "application/json; charset=utf-8"
                 }
               })
    .then((res) => res.json())
    .then((data) => {
      //console.log(data)
      state.offers = data.data.offers
      //emit('render')
      emitter.emit(state.events.RENDER)
    })
     .catch((err) => {
       emit('error', err)
     })
  })
}
