
exports.index  = (cb)      -> ss.rpc('post.index', cb)
exports.show   = (id, cb)  -> ss.rpc('post.show', id, cb)
exports.create = (url, cb) -> ss.rpc('post.create', url, cb)
exports.remove = (id, cb)  -> ss.rpc('post.remove', id, cb)

ss.event.on 'newPost', (post) ->
  post.date = post.createdAt.slice(2,10)
  $('#posts').append ss.tmpl['post-index'].render post

ss.event.on 'removePost', (id) ->
  $("##{id}").remove()

ss.event.on 'newTranslation', (line_id, translation) ->
  $("#post ##{line_id}").append ss.tmpl['post-translation'].render translation

exports.index (posts) ->
  if posts
    for post in posts
      post.date = post.createdAt.slice(2,10)
      $('#posts').append ss.tmpl['post-index'].render post

show = ->
  anchor = location.hash
  if anchor.match /#post\//
    $("#post").show()
    id = anchor.split("#post/")[1]
    exports.show id, (post) ->
      $('.hero-unit').hide()
      post.date = post.createdAt.slice(2,10)
      $('#title').html ss.tmpl['post-title'].render post
      $('#post tbody').html("")
      i = 0
      for line in post.lines
        i += 1
        line["i"] = i
        $('#post tbody').append ss.tmpl['post-original'].render line
        for translation in line.translations
          console.log "#post ##{line._id}"
          $("#post ##{line._id}").append ss.tmpl['post-translation'].render translation

  else
    $("#post").hide()
show()

$(window).bind 'hashchange', show

$("#posts .remove").live "click", ->
  id = $(this).parent().parent()[0].id
  exports.remove id, (success) ->
    if success
      location.hash = ""
      alert('removed!')
    else
      alert('failed!')
$('#newPost').on 'submit', ->
  url = $('#url').val()
  exports.create url, (success) ->
    unless success
      alert('failed!')
    $('#url').val('') # clear text box
