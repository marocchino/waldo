https = require 'https'
url  = require 'url'
Post = require('./models/post').Post
exports.actions = (req, res, ss) ->
  req.use('session')
  index: (conditions = {}) ->
    Post.find conditions, (err, posts) ->
      if not err
        res posts
      else
        res false
  show: (id) ->
    Post.findById id, (err, post) ->
      if not err
        res posts
      else
        res false
  create: (urlStr) ->
    console.log "post.create"
    options = url.parse urlStr
    request = https.get options, (response) ->
      response.on 'data', (data) ->
        @post = new Post()
        @post.url = urlStr
        for line in "#{data}".split /\n/
          @post.lines.push
            orignal: line
        @post.userId = req.session.userId
        @post.save (err) ->
          if not err
            res true
          else
            res false
    request.on 'error', (e) ->
      console.log "error : #{e}"
      res false
