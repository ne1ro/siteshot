# Required modules
fs = require 'fs'
url = require 'url'
path = require 'path'
_ = require 'lodash'
{parseString} = require 'xml2js'
phantom = require 'phantom'
async = require 'async'
mkdirp = require 'mkdirp'


class SiteShot
  constructor: ->
    # Check for config param in arguments
    if process.argv.indexOf('config') isnt -1
      @config()
    else
      config = require "#{process.cwd()}/config.js"

      # Read sitemap.xml
      parseString fs.readFileSync(config.sitemap), (err, result) =>
        if err?
          throw err
        else
          # Get locations list and flatten it
          routes = _.flatten(_.pluck result.urlset.url, 'loc')

          # Async page loading
          phantom.create (ph) =>
            # Load each route in headless server webkit
            pageLoad = (route, callback) =>
              ph.createPage (page) =>
                page.open route, (status) =>
                  if status is 'success'
                    setTimeout (->
                      generateHTML = ->
                        # Get page HTML
                        page.evaluate (-> (new XMLSerializer).serializeToString(document.doctype) + document.documentElement.outerHTML), (res) =>
                          # Set snapshot name
                          snapPrefix = if url.parse(route).path is '/'
                            '/index'
                          else
                            url.parse(route).path

                          snapPath = "#{config.snapshotDir}#{snapPrefix}.html"

                          # Create directory
                          mkdirp path.dirname(snapPath), (err) =>
                            throw err if err?

                            # Write snapshot file
                            fs.writeFile snapPath, res, (err) =>
                              throw err if err?
                              page.close()
                              console.log "Finish loading #{route} and save it in #{snapPath}"
                              callback()

                      if (typeof config.pageModifier is 'function')
                        config.pageModifier(page, ->
                          generateHTML()
                        )
                      else
                        generateHTML()
                    ), config.delay or 0

            # Async page load
            async.eachSeries routes, pageLoad, (err) =>
              throw err if err?

              console.log '----------------------------'
              console.log 'Finish snapshots'
              ph.exit()


  # Generate config file
  config: ->
    example =
      snapshotDir: "#{process.cwd()}/snapshots"
      sitemap: "#{process.cwd()}/sitemap.xml"
      delay: 500
      pageModifier: null

    fs.writeFileSync 'config.js', "module.exports = \
    #{JSON.stringify example, null, 2};"


module.exports = SiteShot
new SiteShot
