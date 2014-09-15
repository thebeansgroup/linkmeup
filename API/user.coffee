class User
  constructor: (@db)->

  index: (approved, cb)->
    @db.User.findAll({where: {approved: approved}, include: [ @db.Link ]}).success( (users) ->
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

  destroy: (id, cb)->
    @db.User.find({where: {id:id},include: [ @db.Link ]}).success( (user)->
      return cb(true,null) if user is null
      user.destroy().success () -> cb(null,{})
    ).error( (error)->
      cb error, null
    )

  create: (attrs, cb)->
    db.User.build(attrs).save()
      .success( (user) -> cb(null, user))
      .error( (error)-> cb(error, null))

  approve: (id, cb)->
    @db.User.find(id).success (user)->
      user.updateAttributes(approved: true).success ->
        cb(null)

  adminise: (id, cb)->
    @db.User.find(id).success (user)->
      user.updateAttributes(admin: true).success ->
        cb(null)



module.exports = User
