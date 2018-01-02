<?php

namespace Genesis_Starter;

class Styles {

	/**
	 * Setup hooks.
	 *
	 * @since 1.0.0
	 */
	public function ready() {
		\add_action( 'admin_init', array( $this, 'admin_init' ) );
		\add_action( 'wp_print_styles', array( $this, 'dequeue' ) );
		\add_filter( 'use_default_gallery_style', '\__return_false' );
	}

	/**
	 * Enqueue editor style.
	 *
	 * Fired on `admin_init`.
	 *
	 * @since 1.0.0
	 */
	public function admin_init() {
		\add_editor_style( 'editor-style.css' );
		\add_editor_style( 'public/fonts.css' );
	}

	/**
	 * Dequeue styles.
	 *
	 * Fired on `wp_print_styles`.
	 *
	 * @since 1.0.0
	 */
	public function dequeue() {
		\wp_dequeue_style( 'dashicons' );
	}

}
