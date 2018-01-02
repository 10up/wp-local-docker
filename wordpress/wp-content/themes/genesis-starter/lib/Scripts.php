<?php

namespace Genesis_Starter;

class Scripts {

	/**
	 * Base URL for public assets.
	 *
	 * @since 1.0.0
	 * @var   string
	 */
	private $base_uri;

	/**
	 * List of CSS assets to cache in localStorage.
	 *
	 * @since 1.0.0
	 * @var   array
	 */
	private $cached_styles;

	/**
	 * Constructor.
	 *
	 * @since 1.0.0
	 */
	public function __construct() {
		$this->base_uri = \get_stylesheet_directory_uri() . '/public/';

		$this->cached_styles = array(
			'fonts' => $this->base_uri . 'fonts.css?version=' . CHILD_THEME_VERSION,
		);
	}

	/**
	 * Setup hooks.
	 *
	 * @since 1.0.0
	 */
	public function ready() {
		\add_action( 'wp_enqueue_scripts', array( $this, 'enqueue' ) );
		\add_action( 'wp_head', array( $this, 'inline' ) );
		\add_filter( 'script_loader_tag', array( $this, 'async' ), 10, 3 );
	}

	/**
	 * Enqueue scripts.
	 *
	 * Fired on `wp_enqueue_scripts`.
	 *
	 * @since 1.0.0
	 */
	public function enqueue() {
		\wp_enqueue_script( 'jquery-core' );

		\wp_enqueue_script( 'genesis-starter-head',
			$this->base_uri . 'head.js',
			array(),
			CHILD_THEME_VERSION, false
		);

		\wp_enqueue_script( 'genesis-starter-infrastructure',
			$this->base_uri . 'infrastructure.js',
			array( 'jquery' ),
			CHILD_THEME_VERSION, true
		);

		\wp_enqueue_script( 'genesis-starter-app',
			$this->base_uri . 'app.js',
			array( 'genesis-starter-infrastructure' ),
			CHILD_THEME_VERSION, true
		);
	}

	/**
	 * Include deferred font loading script in the header.
	 *
	 * @since 1.0.0
	 */
	public function inline() {
		?>
		<!--noptimize-->
		<script type="text/javascript">
			var cachedStyles = <?php echo \wp_json_encode( $this->cached_styles ); ?>;
			<?php include dirname( __DIR__ ) . '/public/inline.js'; ?>
		</script>
		<noscript>
			<?php foreach ( $this->cached_styles as $href ) { ?>
				<link rel="stylesheet" type="text/css" media="all"
					href="<?php echo \esc_url( $href ) ?>">
			<?php } ?>
		</noscript>
		<!--/noptimize-->
		<?php
	}

	/**
	 * Defer script loading.
	 *
	 * @since  1.0.0
	 * @param  string $tag    Script HTML tag.
	 * @param  string $handle Script handle.
	 * @param  string $src    Script URL.
	 * @return string         Filteredd script HTML tag.
	 */
	public function async( $tag, $handle, $src ) {

		if ( \is_admin() ) {
			return $tag;
		}

		$blacklist = array(
			'jquery-core',
			'query-monitor',
		);

		// Do not load certain scripts asynchronously:
		if ( in_array( $handle, $blacklist, true ) ) {
			return $tag;
		}

		return str_replace( "$src'", "$src' async", $tag );
	}
}
