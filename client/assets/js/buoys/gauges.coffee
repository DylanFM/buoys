window._gauges ?= []
(->
  t = document.createElement('script')
  t.async = true
  t.id = 'gauges-tracker'
  t.setAttribute 'data-site-id', '50af53f3f5a1f52ee6000022'
  t.src = '//secure.gaug.es/track.js'
  s = document.getElementsByTagName('script')[0]
  s.parentNode.insertBefore t, s
)()
