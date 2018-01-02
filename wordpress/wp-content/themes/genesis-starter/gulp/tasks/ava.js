import gulp from 'gulp';
import ava from 'gulp-ava';
import config from '../config';

gulp.task('ava', () =>
  gulp.src(config.ava.src)
    .pipe(ava())
);
