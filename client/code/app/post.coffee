
exports.index  = (cb)      -> ss.rpc('post.index', cb)
exports.show   = (id, cb)  -> ss.rpc('post.show', id, cb)
exports.create = (url, cb) -> ss.rpc('post.create', url, cb)
exports.remove = (id, cb)  -> ss.rpc('post.remove', id, cb)

ss.event.on 'newPost', (post) ->
  $('#posts').append ss.tmpl['post-index'].render post
ss.event.on 'removePost', (id) ->
  console.log "##{id}"
  $("##{id}").remove()

exports.index (posts) ->
  if posts
    for post in posts
      $('#posts').append ss.tmpl['post-index'].render post

anchor = location.hash
if anchor.match /#post_/
  id = anchor.split("#post_")[1]
  console.log id
  exports.show id, (post) ->
    for line in post.lines
      console.log line.original

$("#posts .remove").live "click", ->
  id = $(this).parent()[0].id
  exports.remove id, (success) ->
    if success
      alert('removed!')
    else
      alert('failed!')
$('#newPost').on 'submit', ->
  url = $('#url').val()
  exports.create url, (success) ->
    unless success
      alert('failed!')
    $('#url').val('') # clear text box
