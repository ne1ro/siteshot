var SiteShot;

SiteShot = (function() {
  function SiteShot() {
    var parseString, phantom, _;
    this.fs = require('fs');
    if (process.argv.indexOf('config') !== -1) {
      this.config();
    } else {
      this.config = require('../siteshot.json');
      parseString = require('xml2js').parseString;
      _ = require('underscore');
      phantom = require('phantom');
      parseString(this.fs.readFileSync(this.config.sitemap), function(err, result) {
        var routes;
        if (err != null) {
          throw err;
        } else {
          routes = _.flatten(_.pluck(result.urlset.url, 'loc'));
          return _.each(routes, function(route) {
            return phantom.create(function(ph) {
              return ph.createPage(function(page) {
                return page.open(route, function(status) {
                  return console.log(status);
                });
              });
            });
          });
        }
      });
    }
  }

  SiteShot.prototype.config = function() {
    var example;
    example = {
      snapshotDir: "snapshots",
      sitemap: 'sitemap.xml',
      opts: {
        cutImg: true,
        cutJs: true,
        cutCss: true
      }
    };
    return this.fs.writeFileSync('siteshot.json', JSON.stringify(example));
  };

  return SiteShot;

})();

module.exports = SiteShot;

new SiteShot;
