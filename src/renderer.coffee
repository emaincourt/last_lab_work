fs = require 'fs'
pug = require 'pug'

renderFile = (filename, type) ->
  console.log "rendering resource #{filename} of type #{type}"
  Promise.resolve fs.readFileSync "public/#{type}/#{filename}"

renderPug = (filename) ->
  new Promise (resolve, reject) ->
    console.log "rendering pug resource #{filename}"
    try
      html = pug.renderFile "public/pug/#{filename}", pretty: true
      return resolve html
    catch error
      return reject error

module.exports =
  render: (filename, type) ->
    if type == "pug"
      renderPug filename
    else
      renderFile filename,type