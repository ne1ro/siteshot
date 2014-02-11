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
      phantom = require 'phantom'
      async = require 'async'
      url = require 'url'
      path = require 'path'
      mkdirp = require 'mkdirp'

      # Read sitemap.xml
      parseString @fs.readFileSync(@config.sitemap), (err, result) =>
        if err?
          throw err
        else
          # Get locations list and flatten it
          routes = _.flatten(_.pluck result.urlset.url, 'loc')
          # Async page loading
          phantom.create (ph) =>
            # Load each route in headless server webkit
            items = pages = []
            _.each routes, (route, i) =>
              ph.createPage (page) =>
                page.open route, (status) =>
                  if status is 'success'
                    # Get page HTML
                    page.evaluate (-> document.documentElement.outerHTML), (res) =>
                      # Set snapshot name
                      snapPrefix = if url.parse(route).path is '/'
                        '/index'
                      else
                        url.parse(route).path
                      snapPath = "#{@config.snapshotDir}#{snapPrefix}.html"
                      # Create directory
                      mkdirp path.dirname(snapPath), (err) =>
                        throw err if err?

                        # Write snapshot file
                        @fs.writeFile snapPath, res, (err) =>
                          throw err if err?
                          items.push i
                          ph.exit() if items.length is routes.length
                          page.close()

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
