module.exports = (app)->
  api = app.get 'api'
  isAuthenticated = app.get 'isAuthenticated'
  passport = app.get 'passport'

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

  app.get "/awaiting-approval", (req, res)->
    res.render "auth/awaiting"


  app.get "/signup", (req, res) ->
    res.render "signup",
      title: "Express"

  app.post "/signup", (req, res) ->
    api.User.create req.body, (err, user) ->
      return res.send(err) if err
      res.redirect("/awaiting-approval")
