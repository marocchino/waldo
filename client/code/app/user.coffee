exports.current= (cb) ->
  ss.rpc('user.current', cb)

exports.current (user) ->
  if user
    console.log user.name
  else
    html = ss.tmpl['user-login'].render()
    $(html).appendTo("#login")
