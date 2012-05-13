exports.actions = (req, res, ss) ->
  Post = require('../../models/post').Post
  req.use('session')
  remove: (post_id, line_id, id) ->
    Post.findById post_id, (err, post) ->
      if not err
        line = post.lines.id line_id
        if line?
          line.translations.id(id).remove()
          post.save (err) ->
            if not err
              res true
            else
              res false
        else
          res false
      else
        res false
  create: (post_id,line_id, text) ->
    Post.findById post_id, (err, post) ->
      if not err and post?
        line = post.lines.id line_id
        if line?
          translation =
            text:   text
            userId: req.session.userId
          line.translations.push translation
          post.save (err) ->
            if not err
              ss.publish.all('newTranslation', line_id, translation)
              res [true, null]
            else
              res [false, "cant create translation"]
        else
          res [false, "cant find line"]
      else
        res [false, err ? "cant find post"]
