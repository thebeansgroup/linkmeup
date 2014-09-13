module.exports = (app)->
  api = app.get 'api'
  isAuthenticated = app.get 'isAuthenticated'
  passport = app.get 'passport'

  app.get "/", (req, res) ->
    api.User.index (err, users) ->
      console.log users
      res.render "index",
        title: "express",
        users: users

  app.get "/login", (req, res) ->
    res.render "login",
      title: "Express"
      message: req.flash('error')

  app.post "/login", passport.authenticate("local",
    successRedirect: "/"
    failureRedirect: "/login"
    failureFlash: true
  )

  app.get '/logout', (req, res)->
    req.logout()
    res.redirect('/')

  app.get "/signup", (req, res) ->
    res.render "signup",
      title: "Express"

  app.post "/signup", (req, res) ->
    api.User.create req.body, (err, user) ->
      return res.send(err) if err
      passport.authenticate('local')(req, res, () -> res.redirect('/'))

  app.get "/profile/:id", isAuthenticated, (req, res, next) ->
    api.User.show req.params.id, (err, user)->
      next() unless user
      user.getLinks().success (links)->
        res.render "profile",
          title: "title",
          user: user
          links: links
