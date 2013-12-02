'use strict'

module.exports = (grunt) ->

  require('time-grunt') grunt

  require('load-grunt-tasks') grunt
  grunt.initConfig

    bp:
      app: 'app'
      dist: 'dist'
      tmp: '.tmp'

    watch:
      less:
        files: ['<%= bp.app %>/styles/**/*.less']
        tasks: ['less:styles', 'autoprefixer']

      livereload:
        options:
          livereload: '<%= connect.options.livereload %>'

        files: [
          '<%= bp.app %>/*.html'
          '<%= bp.tmp %>/styles/**/*.css'
          '{<%= bp.tmp %>,<%= bp.app %>}/scripts/**/*.js'
          '<%= bp.app %>/images/**/*.{gif,jpeg,jpg,png,svg,webp}'
        ]

    connect:
      options:
        port: 9000
        livereload: 35729
        hostname: '*'

      livereload:
        options:
          open: yes
          base: ['<%= bp.tmp %>', '<%= bp.app %>']

      dist:
        options:
          open: yes
          base: '<%= bp.dist %>'
          livereload: off

    clean:
      dist:
        files: [
          dot: yes
          src: [
            '<%= bp.tmp %>'
            '<%= bp.dist %>/*'
            '!<%= bp.dist %>/.git*'
          ]
        ]

      server: '<%= bp.tmp %>'

    less:
      styles: files:
        '<%= bp.tmp %>/styles/main.css':
          '<%= bp.app %>/styles/main.less'



    autoprefixer:
      options:
        browsers: ['last 1 version']

      dist:
        files: [
          expand: yes
          cwd: '<%= bp.tmp %>'
          src: '/styles/main.css'
          dest: '<%= bp.tmp %>/styles/main.css'
        ]

    rev:
      dist:
        files:
          src: [
            '<%= bp.dist %>/scripts/**/*.js'
            '<%= bp.dist %>/styles/**/*.css'
            # '<%= bp.dist %>/images/**/*.{gif,jpeg,jpg,png,webp}'
            '<%= bp.dist %>/styles/fonts/**/*.*'
          ]

    useminPrepare:
      options:
        dest: '<%= bp.dist %>'

      html: '<%= bp.app %>/index.html'

    usemin:
      options:
        assetsDirs: ['<%= bp.dist %>']

      html: ['<%= bp.dist %>/**/*.html']
      css: ['<%= bp.dist %>/styles/**/*.css']

    cssmin:
      # Defining this task manually b/c either usemin or I am very stupid
      dist:
        files: [
          dest: 'dist/styles/main.css'
          src: '.tmp/concat/styles/main.css'
        ]

    imagemin:
      dist:
        files: [
          expand: yes
          cwd: '<%= bp.app %>/images'
          src: '**/*.{gif,jpeg,jpg,png}'
          dest: '<%= bp.dist %>/images'
        ]

    svgmin:
      dist:
        files: [
          expand: yes
          cwd: '<%= bp.app %>/images'
          src: '**/*.svg'
          dest: '<%= bp.dist %>/images'
        ]

    htmlmin:
      dist:
        options:
          removeCommentsFromCDATA: yes
          # https://github.com/bp/grunt-usemin/issues/44
          collapseWhitespace: no
          collapseBooleanAttributes: no
          removeAttributeQuotes: no
          removeRedundantAttributes: yes
          useShortDoctype: yes
          removeEmptyAttributes: no
          removeOptionalTags: yes

        files: [
          expand: yes
          cwd: '<%= bp.app %>'
          src: '*.html'
          dest: '<%= bp.dist %>'
        ]

    copy:
      dist:
        files: [
          expand: yes
          dot: yes
          cwd: '<%= bp.app %>'
          dest: '<%= bp.dist %>'
          src: [
            '*.{ico,png,txt,xml}'
            'images/**/*.{webp,gif}'
            'styles/fonts/**/*.*'
          ]
        ]

    concurrent:
      dist: ['less', 'imagemin', 'svgmin', 'htmlmin']

  grunt.registerTask 'serve', (target) ->
    if target is 'dist'
      return grunt.task.run ['build', 'connect:dist:keepalive']

    grunt.task.run [
      'clean:server'
      'less'
      'autoprefixer'
      'connect:livereload'
      'watch'
    ]

  grunt.registerTask 'build', [
    'clean:dist'
    'useminPrepare'
    'concurrent:dist'
    'autoprefixer'
    'concat'
    'cssmin:dist'
    'uglify'
    'copy:dist'
    'rev'
    'usemin'
  ]

  grunt.registerTask 'default', ['build']
