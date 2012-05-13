exports.index  = (cb)      -> ss.rpc('post.index', cb)
exports.show   = (id, cb)  -> ss.rpc('post.show', id, cb)
exports.create = (url, cb) -> ss.rpc('post.create', url, cb)
exports.remove = (id, cb)  -> ss.rpc('post.remove', id, cb)
exports.line =
  translation :
    create : (post_id, line_id, text, cb) -> ss.rpc('post.line.translation.create', post_id, line_id, text, cb)

ss.event.on 'newPost', (post) ->
  post.date = post.createdAt.slice(2,10)
  $('#posts').append ss.tmpl['post-index'].render post

ss.event.on 'removePost', (id) ->
  $("##{id}").remove()

ss.event.on 'newTranslation', (line_id, translation) ->
  $("#post ##{line_id} .original").append ss.tmpl['post-translation'].render translation
ss.event.on 'removeTranslation', (id) ->
  $("##{id}").remove()

exports.index (res) ->
  status = res[0]
  if status
    posts = res[1]
    for post in posts
      post.date = post.createdAt.slice(2,10)
      $('#posts').append ss.tmpl['post-index'].render post
  else
    error = res[1]
    console.log error

show = ->
  anchor = location.hash
  if anchor.match /#post\//
    $("#post").show()
    id = anchor.split("#post/")[1]
    exports.show id, (res) ->
      [success, post] = res
      if success
        $('.hero-unit').hide()
        ss.post_id = post._id
        post.date = post.createdAt?.slice(2,10)
        $('#title').html ss.tmpl['post-title'].render post
        $('#post tbody').html("")
        i = 0
        for line in post.lines
          i += 1
          line["i"] = i
          $('#post').append ss.tmpl['post-original'].render line
          for translation in line.translations
            $("#post ##{line._id} .original").append ss.tmpl['post-translation'].render translation

  else
    $("#post").hide()
show()

$(window).bind 'hashchange', show

$("#post form").live "submit", ->
  line_id = $(this).parents("tbody").attr("id")
  input = $(this).find("input")
  exports.line.translation.create ss.post_id, line_id, input.val(), (res) ->
    [ success, message ] = res
    if success
      input.val("")
      input.parents("tbody").next().find("input").focus()
      false
    else
      alert(message)

$("#posts .remove").live "click", ->
  id = $(this).parent().parent()[0].id
  exports.remove id, (res) ->
    [ success, message ] = res
    if success
      location.hash = ""
    console.log message
    alert(message)

$('#newPost').on 'submit', ->
  url = $('#url').val()
  exports.create url, (res) ->
    [ success, message ] = res
    if success
      $('#url').val('') # clear text box
    console.log message
    alert(message)
