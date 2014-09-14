users = require './users'
links = require './links'
hubot = require './hubot'
catchall = require './catchall'

module.exports = (app)->

  #
  # Global helpers
  #

  app.set 'isAuthenticated', (req, res, next) ->
    return next() if req.isAuthenticated()
    res.redirect("/login")

  app.use (req, res, next)->
    res.locals.basedir = app.get('views')
    res.locals.login = req.isAuthenticated()
    res.locals.uid = if req.user then req.user.id else false
    next()

  #
  # Route API
  #

  catchAll: catchall
  users: users
  links: links
  hubot: hubot
