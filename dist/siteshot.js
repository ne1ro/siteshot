var SiteShot;

SiteShot = (function() {
  function SiteShot() {
    this.fs = require('fs');
    if (process.argv.indexOf('config' !== -1)) {
      this.config();
    } else {
      this.config = require('siteshot.json');
    }
  }

  SiteShot.prototype.config = function() {
    var example;
    example = {
      snapshotDir: 'snapshots',
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
