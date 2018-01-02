/**
 * browserify task
 * ---------------
 * Bundle javascripty things with browserify!
 *
 * This task is set up to generate multiple separate bundles, from
 * different sources, and to use Watchify when run from the default task.
 *
 * See browserify.bundleConfigs in gulp/config.js
 */

import gulp from 'gulp';
import glob from 'glob';
import browserify from 'browserify';
import source from 'vinyl-source-stream';
import watchify from 'watchify';
import config from '../config';
import bundleLogger from '../util/bundle-logger';
import {dependencies} from '../../../../../package.json';

let bundleQueue = config.browserify.bundleConfigs.length;

gulp.task('browserify', (callback) => {

  function browserifyThis(bundleConfig) {

    let bundler = browserify({
      cache:        {},
      packageCache: {},
      fullPaths:    false,
      entries:      bundleConfig.entries ? glob.sync(bundleConfig.entries) : null,
      extensions:   config.browserify.extensions,
      debug:        config.browserify.debug
    });

    function bundle() {
      bundleLogger.start(bundleConfig.outputName);
      return bundler.bundle()
        .pipe(source(bundleConfig.outputName))
        .pipe(gulp.dest(bundleConfig.dest))
        .on('end', reportFinished);
    };

    function reportFinished() {
      bundleLogger.end(bundleConfig.outputName);
      if (bundleQueue > 0) {
        bundleQueue--;
        if (bundleQueue === 0) {
          return callback();
        }
      }
    };

    if (bundleConfig.vendor === true) {
      for (let dep in dependencies) {
        bundler.require(dep);
      }
    }

    if (bundleConfig.vendor === false) {
      for (let dep in dependencies) {
        bundler.external(dep);
      }
    }

    if (!config.browserify.debug) {
      bundler.transform({
        global: true
      }, 'uglifyify');
    }

    if (global.isWatching) {
      bundler = watchify(bundler);
      bundler.on('update', bundle);
    }

    return bundle();
  };

  return config.browserify.bundleConfigs.forEach(browserifyThis);
});
