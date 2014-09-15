module.exports = (app)->
  api = app.get 'api'
  isAuthenticated = app.get 'isAuthenticated'
  passport = app.get 'passport'

  auth = require('./auth')(app)
  account = require('./account')(app)


  app.get "/profile/:id", isAuthenticated, (req, res, next) ->
    api.User.show req.params.id, (err, user)->
      next() unless user
      user.getLinks().success (links)->
        res.render "profile",
          title: "title",
          user: user
          links: links
