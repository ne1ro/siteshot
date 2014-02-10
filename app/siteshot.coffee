class SiteShot
  constructor: ->
    @fs = require 'fs'

    # Check for config param in arguments
    if process.argv.indexOf('config') isnt -1
      @config()
    else
      @config = require '../siteshot.json'
      {parseString} = require 'xml2js'
      _ = require 'underscore'

      # Read sitemap.xml
      parseString @fs.readFileSync(@config.sitemap), (err, result) ->
        if err?
          throw err
        else
          # Get locations list and flatten it
          routes = _.flatten(_.pluck result.urlset.url, 'loc')

  # Generate config file
  config: ->
    example =
      snapshotDir: "snapshots"
      sitemap: 'sitemap.xml'
      opts:
        cutImg: yes
        cutJs: yes
        cutCss: yes
    @fs.writeFileSync 'siteshot.json', JSON.stringify example

module.exports = SiteShot
new SiteShot
