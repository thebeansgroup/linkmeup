bcrypt = require('bcrypt')

module.exports = (sequelize, DataTypes) ->
  User = sequelize.define "User", {
      email:
        type: DataTypes.STRING
        unique: true
      hubot_id:
        type: DataTypes.STRING
      admin:
        type: DataTypes.BOOLEAN
        defaultValue: false
      approved:
        type: DataTypes.BOOLEAN
        defaultValue: false
      password: 
        type: DataTypes.STRING
        set: (v) ->
          salt = bcrypt.genSaltSync(10)
          hash = bcrypt.hashSync(v, salt)
          @setDataValue('password', hash)
  },
  {
    instanceMethods:
      addHubot: (id)->
        @setDataValue 'hubot_id', id

      comparePassword: (candidatePassword, cb) ->
        bcrypt.compare candidatePassword, @getDataValue("password"), (err, isMatch) ->
          return cb(err)  if err
          cb null, isMatch
  }
