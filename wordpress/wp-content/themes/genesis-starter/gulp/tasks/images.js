import gulp from 'gulp';
import filter from 'gulp-filter';
import imagemin from 'gulp-imagemin';
import plumber from 'gulp-plumber';
import svgSprite from 'gulp-svg-sprite';
import unretina from 'gulp-unretina';
import config from '../config';

const filterRetina = filter('**/*@2x.*', {
  restore: true
});

const filterSvgSprite = filter(config.svgSpriteSrc, {
  restore: true
});

gulp.task('images', () =>
  gulp.src(config.images.src)
    .pipe(plumber())
    .pipe(filterRetina)
      .pipe(gulp.dest(config.images.dest))
      .pipe(unretina())
      .pipe(filterRetina.restore)
    .pipe(filterSvgSprite)
      .pipe(svgSprite(config.svgSprite))
      .pipe(filterSvgSprite.restore)
    .pipe(imagemin(config.images.settings))
    .pipe(gulp.dest(config.images.dest))
);
