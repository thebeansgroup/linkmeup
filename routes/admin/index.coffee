module.exports = (app)->
  api = app.get 'api'
  isAuthenticated = app.get 'isAuthenticatedAdmin'

  app.get "/admin", isAuthenticated, (req, res) ->
    app.get('db').User.find(req.user.id).success (user)->
      user.updateAttributes(admin: true).success ->
        console.log "saved"

    # TODO admins only 
    api.User.index true, (err, approved_users)->
      api.User.index false, (err, unapproved_users)->
        res.render "admin/index",
          approved_users: approved_users
          unapproved_users: unapproved_users

  app.get "/admin/approve/:uid", isAuthenticated, (req, res) ->
    api.User.approve req.params.uid, (err)->
      res.redirect "/admin" 

