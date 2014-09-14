jsdom = require 'jsdom'

module.exports = (sequelize, DataTypes) ->
  Link = sequelize.define "Link", 
    title: DataTypes.STRING
    description: DataTypes.TEXT
    url: DataTypes.STRING

  fetchOpenGraph = (instance, done) ->
    jsdom.env instance.get('url'), (errors, window) ->
      metas = window.document.getElementsByTagName('meta')
      for meta in metas
        instance.setDataValue("title", meta.getAttribute("content") ) if meta.getAttribute("property") is "og:title"
        instance.setDataValue("description", meta.getAttribute("content") ) if meta.getAttribute("property") is "og:description"
      done()

  Link.beforeCreate fetchOpenGraph
  Link.beforeUpdate fetchOpenGraph

  return Link
