https = require 'https'
url  = require 'url'
Post = require('./models/post').Post
exports.actions = (req, res, ss) ->
  req.use('session')
  index: (conditions = {}) ->
    Post.find conditions, ["_id", "url"], (err, posts) ->
      if not err
        res posts
      else
        res false
  show: (id) ->
    Post.findById id, (err, post) ->
      if not err
        res post
      else
        res false
  remove: (id) ->
    Post.remove _id: id, (err) =>
      if not err
        ss.publish.all('removePost', id)     # Broadcast the message to everyone
        res true
      else
        res false
  create: (urlStr) ->
    options = url.parse urlStr
    request = https.get options, (response) ->
      response.on 'data', (data) ->
        @post = new Post()
        @post.url = urlStr
        for line in "#{data}".split /\n/
          @post.lines.push
            original: line
        @post.userId = req.session.userId
        @post.save (err) =>
          if not err
            ss.publish.all('newPost', @post)     # Broadcast the message to everyone
            res true
          else
            res false
    request.on 'error', (e) ->
      console.log "error : #{e}"
      res false
