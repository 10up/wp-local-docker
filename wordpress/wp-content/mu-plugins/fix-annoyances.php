<?php
/**
 * @wordpress-plugin
 * Plugin Name: Fix WP Annoyances
 * Description: Fixes annoyances in WordPress.
 * Version:     1.0.0
 * Author:      log.OSCON, Lda.
 * Author URI:  https://log.pt/
 * License:     GPL-2.0+
 */

/**
 * Dequeue Jetpack junk.
 *
 * @since 1.0.0
 */
\add_action( 'wp_enqueue_scripts', function() {
	\wp_dequeue_script( 'devicepx' );
}, 99 );

/**
 * Go home, Jetpack, you're drunk.
 *
 * @since 1.0.0
 */
\add_action( 'init', function() {
	\add_action( 'jetpack_holiday_chance_of_snow', '__return_null' );
} );

/**
 * Autoptimize: Do not concatenate inline assets.
 *
 * @since 1.0.0
 */
\add_filter( 'autoptimize_css_include_inline', '__return_false' );
\add_filter( 'autoptimize_js_include_inline', '__return_false' );

/**
 * Excludes JavaScript assets from optimization.
 *
 * @since  1.0.0
 * @param  string $exclude JavaScript assets to exclude in a comma-separated list.
 * @return string          Filtered JavaScript assets to exclude in a comma-separated list.
 */
\add_filter( 'autoptimize_filter_js_exclude', function( $exclude ) {
	return implode( ',', array(
		'jquery.js',
		$exclude,
	) );
} );

/**
 * Excludes CSS assets from optimization.
 *
 * @since  1.0.0
 * @param  string $exclude CSS assets to exclude in a comma-separated list.
 * @return string          Filtered CSS assets to exclude in a comma-separated list.
 */
\add_filter( 'autoptimize_filter_css_exclude', function( $exclude ) {
	return implode( ',', array(
		'customize-support',
		$exclude,
	) );
} );

/**
 * Fix Domain Mapping URLs.
 *
 * @since 1.0.0
 */
function annoyance_domain_mapping_plugins_uri( $full_url, $path = null, $plugin = null ) {
	return str_replace( \get_original_url( 'siteurl' ), \get_option( 'siteurl' ), $full_url );
}

if ( defined( 'DOMAIN_MAPPING' ) ) {
	\add_action( 'plugins_loaded', function() {
		\remove_filter( 'plugins_url', 'domain_mapping_plugins_uri', 1 );
		\add_filter( 'plugins_url', 'annoyance_domain_mapping_plugins_uri', 1 );
	} );
}
