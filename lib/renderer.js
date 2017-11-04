// Generated by CoffeeScript 1.12.7
(function() {
  var fs, pug, renderFile, renderPug;

  fs = require('fs');

  pug = require('pug');

  renderFile = function(filename, type) {
    console.log("rendering resource " + filename + " of type " + type);
    return Promise.resolve(fs.readFileSync("public/" + type + "/" + filename));
  };

  renderPug = function(filename) {
    return new Promise(function(resolve, reject) {
      console.log("rendering pug resource " + filename);
      return pug.renderFile("public/pug/" + filename, {
        pretty: true
      }, function(err, html) {
        return err != null ? err : reject({
          err: resolve(html)
        });
      });
    });
  };

  module.exports = {
    render: function(filename, type) {
      if (type === "pug") {
        return renderPug(filename);
      } else {
        return renderFile(filename, type);
      }
    }
  };

}).call(this);