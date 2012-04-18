https = require 'https'
url  = require 'url'
exports.actions = (req, res, ss) ->
  create: (urlStr) ->
    console.log "post.create"
    options = url.parse urlStr
    request = https.get options, (response) ->
      response.on 'data', (data) ->
        res "#{data}"
    request.on 'error', (e) ->
      console.log "error : #{e}"
      res false
