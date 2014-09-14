module.exports = (app)->
  api = app.get 'api'
  isAuthenticated = app.get 'isAuthenticated'

  app.get "/links", isAuthenticated, (req, res) ->
    api.Link.index (err, links)->
      res.render "links",
        title: "LinkyDinks",
        links: links

  app.get "/link", isAuthenticated, (req, res) ->
    res.render "link"

  app.get "/link/:id", isAuthenticated, (req, res) ->
    api.Link.show req.params.id, (err,link)->
      res.render "link",
        link: link

  app.post "/link", isAuthenticated, (req, res) ->
    api.Link.create req.user.id, req.body, (err, link)->
      return res.send('err') if err
      res.redirect "links"
