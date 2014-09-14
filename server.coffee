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
api           = require('./API')(db)
RedisStore    = require('connect-redis')(session)

#
# Passport
#

serialize_user = require('./auth/serializeUser')(api)
passport.serializeUser serialize_user.serialze
passport.deserializeUser serialize_user.deserialize
passport.use require('./auth/local')(db.User)

#
# Redis for sessions
#

if process.env.REDISTOGO_URL
  rtg   = require('url').parse process.env.REDISTOGO_URL
  redis = require('redis').createClient rtg.port, rtg.hostname
  redis.auth rtg.auth.split(':')[1] # auth 1st part is username and 2nd is password separated by ":"
else
  redis = require("redis").createClient()

#
# Set up
#

app = express()
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.set "port", process.env.PORT or 3000
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use session({secret: 'secretKeyLinks', store: new RedisStore({client: redis}), maxAge: new Date Date.now() + ((3600000*24)*30)  })
app.use express.static(path.join(__dirname, "public"))
app.use passport.initialize()
app.use passport.session()
app.use flash()
app.set "db", db
app.set "api", api
app.set "passport", passport

#
# Define routes
#

routes = require('./routes')(app)
routes.users(app)
routes.admin(app)
routes.links(app)
routes.hubot(app)
routes.catchAll(app)

#
# Lets go
#

db.sequelize.sync().complete (err) ->
  return  throw err[0] if err
  server = app.listen(app.get("port"), ->
    console.log "Express server listening on port " + server.address().port
    return
  )

