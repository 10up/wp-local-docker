<?php

//* Start the engine
include_once \get_template_directory() . '/lib/init.php';

if ( file_exists( \get_stylesheet_directory() . '/vendor/autoload.php' ) ) {
	require_once \get_stylesheet_directory() . '/vendor/autoload.php';
}

//* Child theme (do not remove)
define( 'CHILD_THEME_NAME', 'Genesis Starter' );
define( 'CHILD_THEME_URL', 'https://github.com/log-oscon/wp-genesis-boilerplate' );
define( 'CHILD_THEME_VERSION', '1.0.0' );

//* Set Localization (do not remove)
\load_child_theme_textdomain( 'genesis-starter', \apply_filters(
	'child_theme_textdomain',
	\get_stylesheet_directory() . '/languages',
	'genesis-starter'
) );

//* Add HTML5 markup structure
\add_theme_support( 'html5', array(
	'search-form',
	'comment-form',
	'comment-list',
) );

//* Add support for accessibility features
\add_theme_support( 'genesis-accessibility', array(
	'headings',
	'drop-down-menu',
	'search-form',
	'skip-links',
	'rems',
) );

//* Add viewport meta tag for mobile browsers
\add_theme_support( 'genesis-responsive-viewport' );

//* Add support for custom background
\add_theme_support( 'custom-background' );

//* Add support for 3-column footer widgets
\add_theme_support( 'genesis-footer-widgets', 3 );

//* Setup theme
\add_action( 'after_setup_theme', function () {
	$components = array(
		'scripts'    => new \Genesis_Starter\Scripts(),
		'shortcodes' => new \Genesis_Starter\Shortcodes(),
		'styles'     => new \Genesis_Starter\Styles(),
	);

	/**
	 * Remove/Add components
	 *
	 * Note: if you add a component, make sure it implements a method "ready()".
	 */
	$components = \apply_filters( 'genesis_starter_components', $components );

	foreach ( $components as $name => $instance ) {
		if ( method_exists( $instance, 'ready' ) ) {
			$instance->ready();
		}
	}
} );
