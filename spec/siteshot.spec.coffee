SiteShot = require '../app/siteshot.coffee'

describe 'SiteShot', ->
  beforeEach ->
    @app = new SiteShot

  it 'should be exist', ->
    expect(@app).not.toBeDefined()
    expect(@app).not.toBeNull()
