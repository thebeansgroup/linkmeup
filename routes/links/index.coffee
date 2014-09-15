moment = require('moment')

module.exports = (app)->
  api = app.get 'api'
  isAuthenticated = app.get 'isAuthenticated'
  isAuthenticatedAdmin = app.get 'isAuthenticatedAdmin'

  app.get "/", (req, res) ->
    api.Link.index (err, links)->
      res.render "links",
        links: links,
        moment: moment

  app.get "/link", isAuthenticated, (req, res) ->
    res.render "link"

  app.get "/link/:id", isAuthenticated, (req, res) ->
    api.Link.show req.params.id, (err,link)->
      res.render "link",
        link: link

  app.get "/links/delete/:id", isAuthenticatedAdmin, (req, res) ->
    api.Link.destroy req.params.id, (err,link)->
      res.redirect "/"

  app.post "/link", isAuthenticated, (req, res) ->
    api.Link.create req.user.id, req.body, (err, link)->
      return res.send('err') if err
      res.redirect "/"
