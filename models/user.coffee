bcrypt = require('bcrypt')

module.exports = (sequelize, DataTypes) ->
  User = sequelize.define "User", {
      email: { type: DataTypes.STRING, unique: true }
      password: 
        type: DataTypes.STRING
        set: (v) ->
          salt = bcrypt.genSaltSync(10)
          hash = bcrypt.hashSync(v, salt)
          this.setDataValue('password', hash)
  },
  {
    instanceMethods:
      comparePassword: (candidatePassword, cb) ->
        bcrypt.compare candidatePassword, @getDataValue("password"), (err, isMatch) ->
          return cb(err)  if err
          cb null, isMatch
  }
