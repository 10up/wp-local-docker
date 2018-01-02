<?php

namespace Genesis_Starter;

/**
 * Theme shortcodes.
 */
class Shortcodes {

	/**
	 * Setup shortcode hooks.
	 *
	 * @since 1.0.0
	 */
	public function ready() {
		$this->replace_shortcode( 'gallery', array( $this, 'gallery_shortcode' ) );
	}

	/**
	 * Wraps the gallery shortcode and removes breaks from the output.
	 *
	 * @since 1.0.0
	 */
	public function gallery_shortcode( $attr ) {
		$content = \gallery_shortcode( $attr );
		return preg_replace( '/<br style=([^>]+)>/mi', '', $content );
	}

	/**
	 * Replaces the current shortcode function with the provided callback.
	 *
	 * @since  1.0.0
	 * @access private
	 * @param  string   $tag      Shortcode tag.
	 * @param  callable $callback Shortcode callback.
	 */
	private function replace_shortcode( $tag, $callback ) {
		\remove_shortcode( $tag );
		\add_shortcode( $tag, $callback );
	}
}
