exports.actions = (req, res, ss) ->
  req.use('session')
  User = require('./models/user').User  # See codes below: /server/rpc/models/user.coffee

  current: () ->
    if req.session? and req.session.userId?
      User.findOne {userId: req.session.userId}, (error, user) ->
        unless error?
          if user?
            res user
          else
            @user = new User()
            @user.userId  = req.session.userId
            @user.name    = req.session.name
            @user.email   = req.session.email
            @user.picture = req.session.picture
            @user.save (error) =>
              unless error?
                res @user
              else
                res false
        else
          res error
    else
      res false
