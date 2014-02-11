# Include gulp files
gulp = require 'gulp'
gutil = require 'gulp-util'

# Include gulp plugins
coffee = require 'gulp-coffee'
jasmine = require 'gulp-jasmine'

paths =
  app: 'siteshot.coffee'
  test: 'spec/*.coffee'

gulp.task 'coffee', ->
  gulp.src(paths.app).pipe(coffee(bare: yes).on('error', gutil.log))
    .pipe gulp.dest('.')

gulp.task 'test', ->
  gulp.src(paths.test).pipe jasmine()

gulp.task 'watch', ->
  gulp.watch paths.app, ['coffee', 'test']
  gulp.watch paths.test, ['test']

gulp.task 'default', ['coffee', 'test', 'watch']
