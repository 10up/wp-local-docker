import browserSync from 'browser-sync';
import gulp from 'gulp';
import config from '../config';

gulp.task('browser-sync', ['build'], () =>
  browserSync(config.browserSync)
);
