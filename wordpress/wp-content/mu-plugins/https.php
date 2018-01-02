<?php
/**
 * @wordpress-plugin
 * Plugin Name: HTTPS
 * Description: Fixes and improves HTTPS support.
 * Version:     2.0.0
 * Author:      log.OSCON, Lda.
 * Author URI:  https://log.pt/
 * License:     GPL-2.0+
 */

namespace logoscon\WP\HTTPS;

/**
 * Force URLs in srcset attributes into HTTPS scheme.
 *
 * @since  1.0.0
 * @param  array $sources Source data to include in the 'srcset'.
 * @return array          Possibly-modified source data.
 */
function wp_calculate_image_srcset( $sources ) {
	foreach ( $sources as &$source ) {
		$source['url'] = \set_url_scheme( $source['url'], \is_ssl() ? 'https' : 'http' );
	}
	return $sources;
}

/**
 * Replace http:// with https:// in the embed code (before caching).
 *
 * @since 2.0.0 Changed the function's name to something more meaningfull.
 * @since 1.0.0
 * @param string $data The returned oEmbed HTML.
 * @param string $url  URL of the content to be embedded.
 * @param array  $args Optional arguments, usually passed from a shortcode.
 */
function secure_oembed_result( $data, $url, $args ) {
	return \is_ssl() ? preg_replace( '/http:\/\//', 'https://', $data ) : $data;
}

/**
 * Replace http:// with https:// in the embed code (after caching).
 *
 * @since 2.0.0 Changed the function's name to something more meaningfull.
 * @since 1.0.0
 * @param mixed  $cache   The cached HTML result, stored in post meta.
 * @param string $url     The attempted embed URL.
 * @param array  $attr    An array of shortcode attributes.
 * @param int    $post_id Post ID.
 */
function secure_embed_oembed_html( $cache, $url, $attr, $post_id ) {
	return \is_ssl() ? preg_replace( '/http:\/\//', 'https://', $cache ) : $cache;
}

\add_filter( 'wp_calculate_image_srcset', '\logoscon\WP\HTTPS\wp_calculate_image_srcset', 10, 1 );
\add_filter( 'oembed_result',             '\logoscon\WP\HTTPS\secure_oembed_result',      10, 3 );
\add_filter( 'embed_oembed_html',         '\logoscon\WP\HTTPS\secure_embed_oembed_html',  10, 4 );
