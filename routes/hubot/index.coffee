module.exports = (app)->
  api = app.get 'api'

  app.post '/hubot', (req, res, next)->
    params = req.body
    api.Hubot.request params, (err, obj)->
      if err
        res.statusCode = 403
        next()
      else
        res.json(obj)
