class Link
  constructor: (@db)->

  index: (cb)->
    @db.Link.findAll({include: [ @db.User ]})
      .success( (links) ->
        cb(null, links)
      ).error( (error) -> cb(error, null) )

  show: (id, cb)->
    @db.Link.find(id)
      .success( (link)-> cb(null, link)  )
      .error( (error)-> cb(error, null)  )

  destroy: (id,uid,cb)->
    @db.Link.find(where: {id: id, 'UserId': uid, approved: true})
      .success( (link)->
        return cb(true,null) if link is null
        link.destroy().success () -> cb(null,{})
      ).error( (err)-> cb(err,null)  )

  create: (uid, attrs, cb)->
    @db.User.find(where: {id:uid, approved: true}).success (user)=>
      @db.Link.build(attrs)
        .save().success( (link)->
          user.addLink(link).success (link)-> cb(null, link)
        ).error (error) ->
          cb(error, null)


module.exports = Link
