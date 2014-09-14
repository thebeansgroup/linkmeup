class Hubot
  constructor: (@db)->

  request: (attrs, cb)->
    return cb(true, null) if attrs.key != "B3ANT3AM"
    switch attrs.command
      when "map" then @set_user_id(attrs.from,attrs.remote_username,cb)
      when "unmap" then @set_user_id(attrs.from,null,cb)
      when "post" then @post_link(attrs,cb)
      when "get" then @get_links(cb)

  set_user_id: (email, hid, cb)->
    @db.User.find(where: {email: email}).success(
      (user) ->
        user.addHubot hid
        user.save()
        cb(null,user)
    ).error( (err) -> cb(err, null) )

  post_link: (attrs, cb)->
    @db.User.find(where: {email: attrs.from, hubot_id: attrs.remote_username}).success(
        (user)=>
          return cb("No user", null) unless user
          @db.Link.build({url: attrs.body})
            .save().success( (link)->
              user.addLink(link).success (link)-> cb(null, link)
            ).error (error) ->
              cb(error, null)
    )

  get_links: (cb)->
    @db.Link.findAll({limit: 10}).success(
      (links) -> cb(null, links)
    )


module.exports = Hubot
