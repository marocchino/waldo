# Server-side Code

# Define actions which can be called from the client using ss.rpc('demo.ACTIONNAME', param1, param2...)
exports.actions = (req, res, ss) ->

  # Example of pre-loading sessions into req.session using internal middleware
  req.use('session')
  User = require('./models/user').User  # See codes below: /server/rpc/models/user.coffee

  # Uncomment line below to use the middleware defined in server/middleware/example
  #req.use('example.authenticated')

  sendMessage: (message) ->
    name = if req.session? and req.session.name?
        req.session.name
      else
        "Guest"
    if message && message.length > 0            # Check for blank messages
      ss.publish.all('newMessage', name, message)     # Broadcast the message to everyone
      res(true)                                 # Confirm it was sent to the originating client
    else
      res(false)
