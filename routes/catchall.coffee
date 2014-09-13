module.exports = (app)->
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


