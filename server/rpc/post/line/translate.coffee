exports.actions = (req, res, ss) ->
  Post = require('../../models/post').Post
  req.use('session')
  create: (post_id,line_id, text) ->
    Post.findById post_id, (err, post) ->
      if not err
        line = post.lines.id line_id
        if line?
          translation =
            text:   text
            userId: req.session.userId
          line.translations.push translation
          post.save (err) =>
              if not err
                ss.publish.all('newTranslation', line_id, translation)
                res true
              else
                res false
        else
          res false
      else
        res false
