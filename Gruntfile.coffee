module.exports = (grunt) ->

  grunt.initConfig

    compass:

      dev:
        sassDir: 'assets/scss'
        cssDir: 'assets/css'
        outputStyle: 'expanded'
        environment: 'development'
        noLineComments: false
        debugInfo: true
        force: true

      prod:
        sassDir: 'assets/scss'
        cssDir: 'assets/css'
        outputStyle: 'compressed'
        environment: 'production'
        noLineComments: true
        debugInfo: false
        force: true

  grunt.registerTask('default', 'compass')
  
  grunt.loadNpmTasks('grunt-contrib-compass')
