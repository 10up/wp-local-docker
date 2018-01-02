import gulp from 'gulp';
import del from 'del';
import config from '../config';

gulp.task('clean', () => {
  del(config.dest);
  del('./editor-style.css');
  del('./style.css');
});
