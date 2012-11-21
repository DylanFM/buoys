module.exports = function(grunt) {

  grunt.initConfig({

    compass: {
      dev: {
        src: 'assets/scss',
        dest: 'assets/css',
        outputStyle: 'expanded',
        linecomments: true,
        debugsass: true,
        forcecompile: true
      },
      prod: {
        src: 'assets/scss',
        dest: 'assets/css',
        outputStyle: 'compressed',
        linecomments: false,
        debugsass: false,
        forcecompile: true
      }
    },

    watch: {
      files: ['assets/scss/*.scss'],
      tasks: ['compass:dev']
    }

  })

  grunt.registerTask('default', 'compass:prod')
  
  grunt.loadNpmTasks('grunt-compass')

}
