
module.exports = (sequelize, DataTypes) ->
  Link = sequelize.define "Link",
      url: { type: DataTypes.STRING } 