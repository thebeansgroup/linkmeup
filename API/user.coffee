class User
  constructor: (@db)->

  index: (cb)->
    @db.User.findAll().success( (users) ->
      cb(null, users)
    ).error( (error)->
      cb(error, null)
    )

  show: (id, cb)->
    @db.User.find(id).success( (user)->
      cb(null, user)
    ).error( (error)->
      cb error, null
    )

  create: (attrs, cb)->
    db.User.build(attrs).save()
      .complete( (user) -> cb(null, user))
      .error( (error)-> cb(error, null))

module.exports = User