users = require './users'
admin = require './admin'
links = require './links'
hubot = require './hubot'
catchall = require './catchall'

module.exports = (app)->

  #
  # Global helpers
  #

  app.set 'isAuthenticatedAdmin', (req, res, next) ->
    return next() if req.isAuthenticated() && req.user.approved && req.user.admin
    res.redirect("/login")

  app.set 'isAuthenticated', (req, res, next) ->
    return next() if req.isAuthenticated() && req.user.approved
    res.redirect("/login")

  app.use (req, res, next)->
    res.locals.basedir = app.get('views')
    res.locals.login = req.isAuthenticated()
    res.locals.uid = if req.user then req.user.id else false
    res.locals.current_user = if req.user then req.user else false
    next()

  #
  # Route API
  #

  catchAll: catchall
  users: users
  admin: admin
  links: links
  hubot: hubot
