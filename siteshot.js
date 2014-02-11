#!/usr/bin/env node

// Require modules and libs
var parseXML = require('xml2js').parseString,
  fs = require('fs'),
  _ = require('lodash'),
  phantom = require('phantom'),
  async = require('async'),
  url = require('url'),
  path = require('path'),
  mkdirp = require('mkdirp');

// Generate config if its in args
if (process.argv.indexOf('config') != -1) {
  var example = {
    snapshotsDir: process.cwd() + '/snapshots/',
    sitemap: process.cwd() + '/sitemap.xml'
  };
  fs.writeFileSync(process.cwd() + '/siteshot.json', JSON.stringify(example));
}
else {
  var config = require(process.cwd() + '/siteshot.json');

  // Read sitemap file and parse XML
  parseXML(fs.readFileSync(config.sitemap), function(err, sitemap) {
    if (err) { throw(err);}

    // Get locations list from sitemap
    routes = _.flatten(_.pluck(sitemap.urlset.url, 'loc'));
    console.log(routes);
  });
}

