#!/usr/bin/env node

// Require modules and libs
var xml2js = require('xml2js'),
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
  config = require(process.cwd() + '/siteshot.json');
}

