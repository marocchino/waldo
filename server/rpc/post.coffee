https = require 'https'
url  = require 'url'
Post = require('./models/post').Post
exports.actions = (req, res, ss) ->
  req.use('session')
  #req.use('user.authenticated')
  index: (conditions = {}) ->
    Post.find conditions, ["_id", "title", "createdAt"], (err, posts) ->
      if not err
        res [true, posts]
      else
        res [false, err]
  show: (id) ->
    Post.findById id, (err, post) ->
      if not err
        res [true, post]
      else
        res [false, err]
  preview: (id) ->
    Post.findById id, (err, post) ->
      if not err
        md = require('markdown').markdown
        preview = (for line in post.lines
          if line.translations.length > 0
            line.translations[line.translations.length-1].text
          else
            line.original
        ).join "\n"
        res [true, md.toHTML preview]
      else
        res [false, err]
  remove: (id) ->
    Post.remove _id: id, (err) =>
      if not err
        ss.publish.all('removePost', id)     # Broadcast the message to everyone
        res [true, "successfully removed"]
      else
        res [false, err]
  create: (urlStr) ->
    options = url.parse urlStr
    request = https.get options, (response) ->
      response.on 'data', (data) ->
        @post = new Post()
        @post.url = urlStr
        for line in "#{data}".split /\n/
          if @post.lines.length == 0
            @post.title = line.replace(/^#+\s*/,"")
          @post.lines.push
            original: line
        @post.userId = req.session.userId
        @post.save (err) =>
          if not err
            ss.publish.all('newPost', @post)     # Broadcast the message to everyone
            res [true, "successfully created"]
          else
            res [false, err.err]
    request.on 'error', (e) ->
      res [false, e]
