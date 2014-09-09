express       = require("express")
path          = require("path")
favicon       = require("serve-favicon")
logger        = require("morgan")
cookieParser  = require("cookie-parser")
bodyParser    = require("body-parser")
pg            = require("pg")
passport      = require("passport")
db            = require('./models')
flash         = require('express-flash')
session       = require('express-session')


#
# Passport
#

passport.serializeUser (user, done)->
  done null, user.id

passport.deserializeUser (id, done)->
  db.User.find(id).error(
    (err)-> done(err,null)  
  ).success  (user)->
    done(null, user)

passport.use require('./auth/local')(db.User)

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
app.use session({secret: 'secretKeyLinks'})
app.use express.static(path.join(__dirname, "public"))
app.use passport.initialize()
app.use passport.session()
app.use flash()

#
# Define routes
#

app.use (req, res, next) ->
  res.locals.login = req.isAuthenticated()
  next()

app.get "/", (req, res) ->
  db.User.findAll().success (users) ->
    res.render "index",
      title: "express",
      users: users

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

app.get "/signup", (req, res) ->
  res.render "signup",
    title: "Express"

app.post "/signup", (req, res) ->
  db.User.build(req.body)
    .save().complete( (user) ->
      passport.authenticate('local')(req, res, () -> res.redirect('/'))
    ).error (err) ->
      console.log err
      #res.send 'err'
#
# Post routes.
#
app.get "/links", (req, res) ->
  db.Link.findAll().success (links) ->
    res.render "links",
      title: "LinkyDinks",
      links: links

app.get "/link", (req, res) ->
  res.render "link"

app.post "/link", (req, res) ->
  db.Link.build(req.body)
    .save().complete( (link) ->
      res.redirect "links"
    ).error (err) ->
      res.send 'err'

# 
# Catch all routes
#

app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err

if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err


app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}


#
# Lets go
#

app.set "port", process.env.PORT or 3000

db.sequelize.sync().complete (err) ->
  return  throw err[0] if err
  server = app.listen(app.get("port"), ->
    db.User.findAll().success (users) ->
      console.log arguments
    console.log "Express server listening on port " + server.address().port
    return
  )
