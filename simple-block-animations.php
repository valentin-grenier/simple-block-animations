<?php 

/**
 * Plugin Name: Simple block animations
 * Plugin URI: https://github.com/valentin-grenier/simple-animations-for-gutenberg
 * Description: Easily add animations to your Gutenberg blocks without coding.
 * Version: 1.0.1
 * Requires at least: 
 * Requires PHP: 
 * Tested up to: 6.8
 * Author: Valentin Grenier
 * Author URI: https://www.linkedin.com/in/valentin-grenier/
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: simple-block-animations
 * Domain Path: /languages
 */

// Exit if accessed directly.
if ( ! defined( 'ABSPATH' ) ) {
    exit;
}

define( 'SBA_VERSION', '1.0.0' );
define( 'SBA_PATH', plugin_dir_path( __FILE__ ) );
define( 'SBA_URL', plugin_dir_url( __FILE__ ) );

require_once SBA_PATH . 'includes/class-enqueue.php';
require_once SBA_PATH . 'includes/class-blocks.php';
require_once SBA_PATH . 'includes/class-settings.php';

/**
 * Initialize plugin
 */
function sba_init() {
	SBA_Enqueue::init();
	SBA_Blocks::init();
	SBA_Settings::init();
}
add_action( 'plugins_loaded', 'sba_init' );

/**
 * Activation hook
 */
function sba_activate() {
	// Set default options
	if ( ! get_option( SBA_Settings::OPTION_NAME ) ) {
		add_option(
			SBA_Settings::OPTION_NAME,
			array(
				'enabled_block_types' => array( 'core', 'meta-box' ),
				'default_duration'    => 0.6,
				'default_delay'       => 0,
			)
		);
	}

	flush_rewrite_rules();
}
register_activation_hook( __FILE__, 'sba_activate' );

/**
 * Deactivation hook
 */
function sba_deactivate() {
	flush_rewrite_rules();
}
register_deactivation_hook( __FILE__, 'sba_deactivate' );