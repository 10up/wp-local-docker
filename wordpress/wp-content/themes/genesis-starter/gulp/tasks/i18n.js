import gulp from 'gulp';
import wpPot from 'gulp-wp-pot';
import sort from 'gulp-sort';
import config from '../config';

gulp.task('i18n', () =>
  gulp.src(config.i18n.src)
    .pipe(sort())
    .pipe(wpPot({
        domain: config.i18n.textDomain,
        destFile: config.i18n.potFilename + '.pot',
        package: config.i18n.pluginSlug,
        bugReport: config.i18n.support,
        lastTranslator: config.i18n.author,
        team: config.i18n.author,
        headers: false
  }))
  .pipe(gulp.dest(config.i18n.dest))
);
