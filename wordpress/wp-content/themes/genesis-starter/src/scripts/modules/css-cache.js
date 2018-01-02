/**
 * Add event listener.
 *
 * @since 1.0.0
 * @param {DOMElement} element  DOM element to attach event to.
 * @param {String}     event    Event name.
 * @param {Function}   callback Event handler.
 */
function on(element, event, callback) {
  if (element.addEventListener) {
    element.addEventListener(event, callback, false);
  } else if (element.attachEvent) {
    element.attachEvent('on' + event, callback);
  }
}

/**
 * Fetch CSS from localStorage.
 *
 * @since  1.0.0
 * @param  {String} key Cache key.
 * @return {String}     Cached CSS contents.
 */
function getCache(key) {
  return window.localStorage && window.localStorage['cssCache_' + key];
}

/**
 * Cache CSS in localStorage.
 *
 * @since 1.0.0
 * @param {String} key  Cache key.
 * @param {String} url  Cached URL.
 * @param {String} text Cached URL contents.
 */
function putCache(key, url, text) {
  window.localStorage['cssCache_' + key] = text;
  window.localStorage['cssCacheUrl_' + key] = url;
}

/**
 * Check whether the URL is in cache.
 *
 * @since  1.0.0
 * @param  {String} key Cache key.
 * @param  {String} url URL to check.
 * @return {Boolean}    Whether the URL is in cache.
 */
function isCached(key, url) {
  return window.localStorage && window.localStorage['cssCacheUrl_' + key] === url;
}

/**
 * Inject raw styles inline.
 *
 * @since 1.0.0
 * @param {String} text Inline style block.
 */
function injectStyleText(text) {
  const style = document.createElement('style');
  style.setAttribute('type', 'text/css');

  if (style.styleSheet) {
    style.styleSheet.cssText = text;
  } else {
    style.innerHTML = text;
  }

  document.getElementsByTagName('head')[0].appendChild(style);
}

/**
 * Inject stylesheet URL in document `<head>`.
 *
 * The URL must be in the same domain as the loading application.
 *
 * @since 1.0.0
 * @param {String} url Stylesheet URL.
 */
function injectStyle(key, url) {
  if (!window.localStorage || !window.XMLHttpRequest) {
    const stylesheet = document.createElement('link');

    stylesheet.href = url;
    stylesheet.rel  = 'stylesheet';
    stylesheet.type = 'text/css';

    document.getElementsByTagName('head')[0].appendChild(stylesheet);
    document.cookie = 'cssCache_' + key;
    return;
  }

  if (isCached(key, url)) {
    injectStyleText(getCache(key));
    return;
  }

  const xhr = new XMLHttpRequest();
  xhr.open('GET', url, true);
  xhr.onreadystatechange = function() {
    if (xhr.readyState === 4) {
      injectStyleText(xhr.responseText);
      putCache(key, url, xhr.responseText);
    }
  };

  xhr.send();
}

/**
 * Require a (possibly cached) CSS URL for injection.
 *
 * @since 1.0.0
 * @param {String} key Cache key.
 * @param {String} url URL for the required CSS.
 */
function require(key, url) {
  if (isCached(key, url) || document.cookie.indexOf('cssCache_' + key) > -1) {
    // Fonts in cache, load them now:
    injectStyle(key, url);
  } else {
    // Defer loading of fonts:
    on(window, 'load', () => injectStyle(key, url));
  }
}

export default {
  require
};
