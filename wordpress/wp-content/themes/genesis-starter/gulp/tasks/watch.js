/**
 * Notes:
 * - gulp/tasks/browserify.js handles js recompiling with watchify
 * - gulp/tasks/browserSync.js watches and reloads compiled files
 */

import gulp from 'gulp';
import config from '../config';

gulp.task('watch', ['set-watch', 'browser-sync'], () => {
  gulp.watch(config.sass.src, ['sass']);
  gulp.watch(config.fonts.src, ['fonts'])
  gulp.watch(config.images.src, ['images']);
  gulp.watch(config.eslint.src, ['eslint']);
  // gulp.watch(config.phpunit.watch, ['phpunit']);
  // gulp.watch(config.tape.watch, ['tape']);
});
