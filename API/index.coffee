Link = require('./link')
User = require('./user')
Hubot = require('./hubot')

module.exports = (db)->
  {
    Link: new Link(db)
    User: new User(db)
    Hubot: new Hubot(db)
  }
