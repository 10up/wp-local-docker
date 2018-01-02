import gulp from 'gulp';
import phpunit from 'gulp-phpunit';
import config from '../config';

gulp.task('phpunit', () =>
  gulp.src(config.phpunit.src)
    .pipe(phpunit())
);
