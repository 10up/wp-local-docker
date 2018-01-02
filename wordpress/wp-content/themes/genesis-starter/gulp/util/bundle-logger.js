import {log, colors} from 'gulp-util';
import prettyHrtime from 'pretty-hrtime';

let startTime;

export default {
  start: function(filepath) {
    startTime = process.hrtime();
    return log(`Bundled ${colors.green(filepath)}...`);
  },

  end: function(filepath) {
    const taskTime   = process.hrtime(startTime);
    const prettyTime = prettyHrtime(taskTime);

    return log(`Bundled ${colors.green(filepath)} in ${colors.magenta(prettyTime)}`);
  }
};
