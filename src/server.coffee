fs = require 'fs'
url = require 'url'
pug = require 'pug'
renderer = require './renderer'

renderResource = (filename, type, res, callback) ->
  try
    if fs.existsSync "public/#{type}/#{filename}"
      renderer.render(filename, type).then (content) ->
        res.writeHead 200
        res.write content
        res.end()
    else
      res.writeHead 404,
        'Content-Type': "text/#{type}"
      res.write 'File not found'
      res.end()
  catch error
    console.log error
    res.writeHead 502,
        'Content-Type': "text/plain"
      res.write 'Unable to forward the file'
      res.end()
    

module.exports = 
  logic: (req, res) ->
    try
      url = url.parse req.url
      [ _, directory, filetype, filename ] = url.pathname.split "/"
      directory = "/" if directory == ""
      
      switch directory
        when "/"
          renderResource "index.pug", "pug", res
        when "page1"
          renderResource "articles/page1.pug", "pug", res
        when "page2"
          renderResource "articles/page2.pug", "pug", res
        when "page3"
          renderResource "articles/page3.pug", "pug", res
        when "public"
          renderResource filename, filetype, res
        else 
          res.writeHead 404, 
            'Content-Type': 'text/plain'
          res.end "Error 404: not found"
    catch error
      res.writeHead 500,
        'Content-Type': 'text/plain'
      res.end "Too bad we're down"
    
  port: "8888"
  address: "127.0.0.1"
