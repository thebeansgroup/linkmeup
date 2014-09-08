module.exports = 
  init:-> console.log "hello lwowelk"

express = require("express")
path = require("path")
favicon = require("serve-favicon")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
pg = require("pg")
passport = require("passport")
db      = require('./models')
flash = require('express-flash')
session = require('express-session')

#
# Set up
#

app = express()

app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use session({secret: 'secretKey'})
app.use express.static(path.join(__dirname, "public"))

app.use passport.initialize()
app.use passport.session()
app.use flash()
passport.use require('./auth/local')(db.User)

#
# Define routes
#

app.get "/login", (req, res) ->
  res.render "login",
    title: "Express"
    message: req.flash('error')

app.post "/login", passport.authenticate("local",
  successRedirect: "/"
  failureRedirect: "/login"
  failureFlash: true
)

app.get "/signup", (req, res) ->
  res.render "signup",
    title: "Express"

app.post "/signup", (req, res) ->
  db.User.build(req.body)
    .save().complete (err,user) ->
      # console.log(err) if err
      console.log user
      res.send 'done'

#
# Catch all routes
#

app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return

if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return

app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return



#
# Lets go
#

app.set "port", process.env.PORT or 3000

db.sequelize.sync({force: true}).complete (err) ->
  if err
    throw err[0]
  else
    server = app.listen(app.get("port"), ->
      db.User.findAll().success (users) ->
        console.log arguments
      console.log "Express server listening on port " + server.address().port
      return
    )
