fs = require 'fs'
url = require 'url'
pug = require 'pug'

renderResource = (filename, type, res, callback) ->
  if type == "html"
    console.log "rendering pug resource #{filename}"
    pug.renderFile "views/#{filename}", 
      pretty: true
    , (err, html) ->
      throw err if err 
      res.writeHead 200, 
        'Content-Type': "text/#{type}"
      res.write html
      res.end()
      
  else if type == "css"
    console.log "rendering resource #{filename} of type #{type}"
    fs.readFile "public/#{type}/#{filename}", (err, file) ->
      throw err if err 
      res.writeHead 200, 
        'Content-Type': "text/#{type}"
      res.write file
      res.end()

module.exports = 
  logic: (req, res) ->
    url = url.parse req.url
    [ _, directory, filetype, filename ] = url.pathname.split "/"
    directory = "/" if directory == ""
    
    switch directory
      when "/"
        renderResource "index.pug", "html", res
      when "page1"
        renderResource "page1.pug", "html", res
      when "public"
        renderResource filename, filetype, res
      else 
        res.writeHead 404, 
          'Content-Type': 'text/plain'
        res.end 'Error 404: not found\n'
    
  port: "8888"
  address: "127.0.0.1"
