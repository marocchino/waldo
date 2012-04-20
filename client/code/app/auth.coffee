exports.current= (cb) ->
  ss.rpc('user.current', cb)

exports.current (user) ->
  if user
    alert 1
  else
    alert 2
