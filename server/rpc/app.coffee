exports.actions = (req, res, ss) ->
  req.use('session')
  square: (number) -> res number*number
  create: (url) -> res "ok"
