users = require './users'
links = require './links'
hubot = require './hubot'
catchall = require './catchall'

module.exports = (app)->

  #
  # Global helpers
  #

  app.set 'isAuthenticated', (req, res, next) ->
    res.locals.login = req.isAuthenticated()
    next()

  #
  # Route API
  #

  catchAll: catchall
  users: users
  links: links
  hubot: hubot
