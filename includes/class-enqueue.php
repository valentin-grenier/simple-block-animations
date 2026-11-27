<?php
/**
 * Asset management class
 *
 * @package SIMPBLAN
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Handles enqueueing of editor and frontend assets
 */
class SIMPBLAN_Enqueue {

	/**
	 * Shared handle for the frontend script and style
	 */
	const FRONTEND_HANDLE = 'simple-block-animations-frontend';

	/**
	 * Handle for the editor script and style
	 */
	const EDITOR_HANDLE = 'simple-block-animations-editor';

	/**
	 * Initial transform per animation type, printed inline in the head
	 *
	 * @var array
	 */
	private static $initial_transforms = array(
		'fade-in-up'    => 'translateY(2rem)',
		'fade-in-down'  => 'translateY(-2rem)',
		'fade-in-left'  => 'translateX(-2rem)',
		'fade-in-right' => 'translateX(2rem)',
		'zoom-in'       => 'scale(0.9)',
		'slide-up'      => 'translateY(3rem)',
	);

	/**
	 * Initialize hooks
	 */
	public static function init() {
		add_action( 'enqueue_block_editor_assets', array( __CLASS__, 'enqueue_editor_assets' ) );
		add_action( 'wp_enqueue_scripts', array( __CLASS__, 'register_frontend_assets' ) );
		add_action( 'wp_head', array( __CLASS__, 'print_initial_state' ), 1 );
	}

	/**
	 * Enqueue editor assets (Block Editor only)
	 */
	public static function enqueue_editor_assets() {
		wp_enqueue_script(
			self::EDITOR_HANDLE,
			SIMPBLAN_URL . 'build/editor.js',
			array( 'wp-blocks', 'wp-dom', 'wp-i18n', 'wp-hooks', 'wp-compose', 'wp-element', 'wp-block-editor', 'wp-components' ),
			SIMPBLAN_VERSION,
			true
		);

		wp_enqueue_style(
			self::EDITOR_HANDLE,
			SIMPBLAN_URL . 'build/editor.css',
			array( 'wp-edit-blocks' ),
			SIMPBLAN_VERSION
		);

		// Expose the saved defaults so newly inserted blocks pick them up.
		wp_add_inline_script(
			self::EDITOR_HANDLE,
			'window.simpblanDefaults = ' . wp_json_encode( SIMPBLAN_Settings::get_settings() ) . ';',
			'before'
		);

		wp_set_script_translations(
			self::EDITOR_HANDLE,
			'simple-block-animations',
			SIMPBLAN_PATH . 'languages'
		);
	}

	/**
	 * Register frontend assets without enqueueing them
	 *
	 * They are enqueued on demand by SIMPBLAN_Blocks as soon as an animated block is
	 * actually rendered, which covers dynamic blocks, block templates, template parts
	 * and synced patterns alike.
	 */
	public static function register_frontend_assets() {
		wp_register_script(
			self::FRONTEND_HANDLE,
			SIMPBLAN_URL . 'build/frontend.js',
			array(),
			SIMPBLAN_VERSION,
			true
		);

		wp_register_style(
			self::FRONTEND_HANDLE,
			SIMPBLAN_URL . 'build/frontend.css',
			array(),
			SIMPBLAN_VERSION
		);
	}

	/**
	 * Enqueue the registered frontend assets
	 */
	public static function enqueue_frontend_assets() {
		if ( is_admin() ) {
			return;
		}

		wp_enqueue_script( self::FRONTEND_HANDLE );
		wp_enqueue_style( self::FRONTEND_HANDLE );
	}

	/**
	 * Build the selector of the initial hidden state for one animation type
	 *
	 * It requires both the class and the data attribute that SIMPBLAN_Blocks adds at
	 * render time, so an element from a theme or another plugin that merely carries a
	 * class containing "animate-" is never hidden.
	 *
	 * @param string $type Animation type.
	 * @return string CSS selector.
	 */
	private static function get_initial_state_selector( $type ) {
		return sprintf(
			'html.simpblan-js .animate-%1$s[data-animation="%1$s"]:not(.is-visible)',
			$type
		);
	}

	/**
	 * Print the initial hidden state in the head
	 *
	 * Blocks are rendered after wp_head, so the stylesheet enqueued at render time lands
	 * in the footer. Without this, an animated block would paint visible before being
	 * hidden. The rules are gated behind a class set by the inline script below, so a
	 * visitor without JavaScript never gets stuck on hidden content. The same script
	 * removes the class on window load when frontend.js has not flagged itself as running.
	 */
	public static function print_initial_state() {
		$selectors = array();

		foreach ( array_keys( SIMPBLAN_Blocks::get_animation_types() ) as $type ) {
			$selectors[ $type ] = self::get_initial_state_selector( $type );
		}

		$all = implode( ',', $selectors );
		$css = $all . '{opacity:0}';

		foreach ( self::$initial_transforms as $type => $transform ) {
			if ( isset( $selectors[ $type ] ) ) {
				$css .= sprintf( '%s{transform:%s}', $selectors[ $type ], $transform );
			}
		}

		// Same specificity as the rules above, so source order settles it.
		$css .= '@media(prefers-reduced-motion:reduce){' . $all . '{opacity:1;transform:none}}';

		printf(
			'<style id="simpblan-initial-state">%s</style>',
			$css // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped -- Static CSS built from hardcoded maps.
		);

		// Safety net: if the frontend script has not run by the time the page has loaded
		// (blocked, failed, or no IntersectionObserver), drop the class so content shows.
		wp_print_inline_script_tag(
			"document.documentElement.className+=' simpblan-js';" .
			"window.addEventListener('load',function(){if(!window.simpblanReady){document.documentElement.classList.remove('simpblan-js');}});"
		);
	}
}
