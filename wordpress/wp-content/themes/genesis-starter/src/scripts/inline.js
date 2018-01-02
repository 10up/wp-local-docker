import cssCache from './modules/css-cache';

const cachedStyles = window.cachedStyles || {};

for (let key in cachedStyles) {
  cssCache.require(key, cachedStyles[key]);
}
