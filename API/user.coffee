class User
  constructor: (@db)->

  index: (cb)->
    @db.User.findAll({include: [ @db.Link ]}).success( (users) ->
      cb(null, users)
    ).error( (error)->
      cb(error, null)
    )

  show: (id, cb)->
    @db.User.find({where: {id:id},include: [ @db.Link ]}).success( (user)->
      cb(null, user)
    ).error( (error)->
      cb error, null
    )

  create: (attrs, cb)->
    db.User.build(attrs).save()
      .success( (user) -> cb(null, user))
      .error( (error)-> cb(error, null))

module.exports = User
