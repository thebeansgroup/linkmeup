module.exports = (api)->
  serialze: (user, done)-> done null, user.id
  deserialize: (id, done)->
    api.User.show id, (err, user)->
      return done(err, null) if err
      done(null, user)
