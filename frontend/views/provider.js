// import choo's template helper
var html = require('choo/html')

module.exports = function (provider, i) {
  var name = provider.name
  var slug = provider.slug
  var url = provider.urls
  var domain = provider.domain

  // create html template
  return html`
   <div class="provider">
    <a href="/provider/${slug}">
      <p>Was mit ${domain}</p>
      <h2>${slug.toUpperCase()}</h2>
      <h3>${name}</h3>
    </a>
   </div>
  `

}
