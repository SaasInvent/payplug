var gulp = require('gulp');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');


// payplug module

gulp.task('lib', function () {
    return gulp.src('./src/*.coffee')
      .pipe(coffee({bare: true}).on('error', gutil.log))  
      .pipe(gulp.dest('./lib/'));
});

gulp.task('test', function () {
    return gulp.src('./test/*.coffee')
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(gulp.dest('./test/'));
});

gulp.task('default', ['lib', 'test'], function () {});
