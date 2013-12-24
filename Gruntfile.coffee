module.exports = (grunt) ->
  grunt.initConfig

    clean:
      all: ['index.html']

    coffeelint:
      gruntfile: 'Gruntfile.coffee'
      options: max_line_length: { value: 120 }

    connect:
      server: options: base: '.'

    jade:
      compile:
        files:
          'index.html': 'index.jade'
      options:
        pretty: true
        pretty$release: false

    update:
      tasks: ['jade']

    watch:
      options:
        livereload: true
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['coffeelint:gruntfile']
      jade:
        files: 'index.jade'
        tasks: 'jade'

  require('load-grunt-tasks')(grunt)

  # grunt.registerTask 'build', ['clean:target', 'browserify', 'copy', 'jade', 'sass']
  # grunt.registerTask 'build:release', ['contextualize:release', 'build']
  # grunt.registerTask 'deploy', ['build:release', 'gh-pages']
  grunt.registerTask 'default', ['update', 'connect', 'autowatch']