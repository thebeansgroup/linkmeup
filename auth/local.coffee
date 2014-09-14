LocalStrategy = require("passport-local").Strategy

module.exports = (User) ->
  new LocalStrategy {usernameField: 'email'}, (email, password, done) ->
    console.log email
    User.find( where: {email: email}).error(
      (err) -> return done(err) 
    ).success (user) ->
      return done(null,false, message: "User awaiting approval") unless user.approved 
      return done(null, false, message: "Incorrect email.") unless user
      user.comparePassword password, (err, match) ->
        return done(null, false, message: "Incorrect password.") unless match
        done null, user

