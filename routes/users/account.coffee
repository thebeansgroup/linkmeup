module.exports = (app)->
  api = app.get 'api'
  isAuthenticated = app.get 'isAuthenticated'

  app.get "/account/:id", (req, res) ->
    res.render "account/index",
      title: "Account"

  app.get "/account/:id/link/:linkID/delete", isAuthenticated ,(req, res, next) ->
    next() if req.params.id.toString() != req.user.id.toString()
    api.Link.destroy req.params.linkID, req.user.id, (err)->
      console.log err
      res.redirect "/account/#{req.params.id}/links"

    
  app.get "/account/:id/links", isAuthenticated, (req, res, next) ->
    api.User.show req.params.id, (err, user)->
      next() unless user
      res.render "account/links",
        title: "Links",
        user: user
        links: user.links
