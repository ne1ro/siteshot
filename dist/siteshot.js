var SiteShot;

SiteShot = (function() {
  function SiteShot() {
    var parseString, _;
    this.fs = require('fs');
    if (process.argv.indexOf('config') !== -1) {
      this.config();
    } else {
      this.config = require('../siteshot.json');
      parseString = require('xml2js').parseString;
      _ = require('underscore');
      parseString(this.fs.readFileSync(this.config.sitemap), function(err, result) {
        var routes;
        if (err != null) {
          throw err;
        } else {
          return routes = _.flatten(_.pluck(result.urlset.url, 'loc'));
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
