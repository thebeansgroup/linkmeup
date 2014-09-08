LocalStrategy = require("passport-local").Strategy

auth = (username, password, done) ->
  User.findOne username: username, (err, user) ->
    return done(err)  if err
    unless user
      return done(null, false,
        message: "Incorrect username."
      )
    unless user.validPassword(password)
      return done(null, false,
        message: "Incorrect password."
      )
    done null, user

module.exports = (User) ->
 return new LocalStrategy auth
