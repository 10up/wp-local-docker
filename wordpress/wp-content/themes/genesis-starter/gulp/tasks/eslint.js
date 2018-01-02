import gulp from 'gulp';
import eslint from 'gulp-eslint';
import config from '../config';

gulp.task('eslint', () =>
  gulp.src(config.eslint.src)
    .pipe(eslint())
    .pipe(eslint.format())
);
