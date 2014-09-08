module.exports = (sequelize, DataTypes) ->
  sequelize.define "User",
      username: DataTypes.STRING
