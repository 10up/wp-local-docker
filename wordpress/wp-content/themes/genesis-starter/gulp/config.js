import hasFlag from 'has-flag';
import findupNodeModules from 'findup-node-modules';

const host      = 'local.wordpress.dev';
const src       = './src';
const dest      = './public';
const test      = './test';
const languages = './languages';
const debug     = hasFlag('debug');

export default {
  src,
  dest,
  environment: {
    debug
  },
  sass: {
    src: src + '/styles/**/*.{sass,scss}',
    dest: './',
    settings: {
      sourceComments: debug ? 'map' : null,
      imagePath: 'public/images',
      includePaths: [
        findupNodeModules('modularized-normalize-scss'),
        findupNodeModules('susy/sass')
      ]
    }
  },
  autoprefixer: {
    browsers: ['last 2 versions']
  },
  fonts: {
    src: src + '/fonts/**/*.{ttf,woff,woff2}',
    out: 'fonts.css',
    dest,
  },
  i18n: {
    src: [
      '**/*.php',
      '!languages/',
      '!gulp/',
      '!src/',
      '!test/',
      '!public/',
      '!vendor/',
      '!node_modules',
      'build/',
      'svn/'
    ],
    dest: languages,
    author: 'log <engenharia@log.pt>',
    support: 'http://log.pt',
    pluginSlug: 'genesis-starter',
    textDomain: 'genesis-starter',
    potFilename: 'genesis-starter'
  },
  images: {
    src: [
      src + '/images/**',
      '!' + src + '/images/svg-sprite'
    ],
    dest: dest + '/images',
    settings: {
      svgoPlugins: [
        {
          cleanupIDs: false
        },
        {
          removeUnknownsAndDefaults: {
            SVGid: false
          }
        }
      ]
    }
  },
  svgSpriteSrc: '**/svg-sprite/**/*.svg',
  svgSprite: {
    svg: {
      rootAttributes: {
        height: 0,
        width:  0,
        style:  'position: absolute'
      }
    },
    mode: {
      inline: true,
      symbol: {
        dest: '',
        sprite: 'sprite.svg'
      }
    }
  },
  eslint: {
    src: src + '/scripts/**/*.{js,jsx}'
  },
  phpunit: {
    watch: '/**/*.php',
    src: test + '/phpunit/**/*.test.php'
  },
  ava: {
    src: test + '/ava/**/*.js'
  },
  browserSync: {
    proxy: host,
    files: [
      '*.css',
      '**/*.php',
      dest + '/**',
      '!**/*.map',
      '!' + test + '/**/*.php'
    ]
  },
  browserify: {
    debug: debug,
    extensions: ['.jsx', '.yaml', '.json', '.hbs', '.dust'],
    bundleConfigs: [
      {
        entries: src + '/scripts/app.js',
        dest,
        outputName: 'app.js',
        vendor: false
      }, {
        dest,
        outputName: 'infrastructure.js',
        vendor: true
      }, {
        entries: src + '/scripts/head.js',
        dest,
        outputName: 'head.js'
      }, {
        entries: src + '/scripts/inline.js',
        dest,
        outputName: 'inline.js'
      }
    ]
  }
};
