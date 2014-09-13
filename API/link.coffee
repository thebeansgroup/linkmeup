class Link
  constructor: (@db)->

  index: (cb)->
    @db.Link.findAll()
      .success( (links) ->
        cb(null, links)
      ).error( (error) ->
        cb(error, null)
      )

  show: (id, cb)->
    @db.Link.find(id)
      .success( (link)-> cb(null, link)  )
      .error( (error)-> cb(error, null)  )

  create: (uid, attrs, cb)->
    @db.User.find(uid).success (user)=>
      @db.Link.build(attrs)
        .save().success( (link)->
          user.addLink(link).success (link)-> cb(null, link)
        ).error (error) ->
          cb(error, null)


module.exports = Link
