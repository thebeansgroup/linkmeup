module.exports = (sequelize, DataTypes) ->
  User = sequelize.define "User",
      username: DataTypes.STRING
      password: DataTypes.STRING
