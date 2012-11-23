window._crashmat = key: "sv7i"

((w, d, cm, woe) ->
  w.onerror = (e,f,l,c) ->
    cm.e = cm.e || []
    cm.e.push([e,f,l,c])
    woe(e,f,l,c) if woe 
  e = d.createElement('script')
  e.async = true
  e.src = '//db2uk9yp28y61.cloudfront.net/'
  (d.head || d.getElementsByTagName('head')[0]).appendChild(e)
)(window, document, window._crashmat, window.onerror)
