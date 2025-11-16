=== Animate Gut Blocks ===
Contributors: valentingrenier
Tags: gutenberg, blocks, animation, scroll, effects
Requires at least: 5.8
Tested up to: 6.8
Requires PHP: 7.4
Stable tag: 1.0.0
License: GPLv2 or later
License URI: https://www.gnu.org/licenses/gpl-2.0.html

Easily add smooth scroll animations to your Gutenberg blocks without writing a single line of code.

== Description ==

Animate Blocks is a lightweight WordPress plugin that brings your Gutenberg editor to life by adding beautiful scroll-triggered animations to any block. Perfect for creating engaging, modern websites with minimal effort.

= Key Features =

* **No Coding Required** - Add animations directly from the block inspector panel
* **Multiple Animation Types** - Choose from fade-in, slide-up, slide-down, slide-left, and slide-right effects
* **Customizable Settings** - Control animation duration and delay for each block
* **Scroll Trigger** - Animations activate when blocks enter the viewport
* **Performance Optimized** - Lightweight JavaScript with Intersection Observer API
* **Works with Core Blocks** - Compatible with all WordPress core blocks
* **Block-Level Control** - Enable/disable animations per block

= Supported Animation Types =

* Fade In
* Fade In Up (slide from bottom)
* Fade In Down (slide from top)
* Fade In Left (slide from left)
* Fade In Right (slide from right)

= How It Works =

1. Edit any Gutenberg block in the editor
2. Open the block settings panel (right sidebar)
3. Enable the animation toggle
4. Choose your preferred animation type
5. Adjust duration and delay (optional)
6. Publish and watch your blocks come to life!

The plugin uses the modern Intersection Observer API to detect when blocks enter the viewport, ensuring smooth performance even on content-heavy pages.

= Perfect For =

* Landing pages
* Portfolio websites
* Marketing sites
* Blog posts with visual flair
* Any site that wants to add subtle motion

== Installation ==

= Automatic Installation =

1. Log in to your WordPress admin panel
2. Navigate to Plugins > Add New
3. Search for "Animate Blocks"
4. Click "Install Now" and then "Activate"

= Manual Installation =

1. Download the plugin ZIP file
2. Log in to your WordPress admin panel
3. Navigate to Plugins > Add New > Upload Plugin
4. Choose the downloaded ZIP file and click "Install Now"
5. Activate the plugin

= After Activation =

1. Go to Settings > Block Animations to configure default options
2. Edit any post or page with the Gutenberg editor
3. Select a block and enable animations from the block settings panel

== Frequently Asked Questions ==

= Does this plugin work with all blocks? =

The plugin currently supports all WordPress core blocks and Meta Box blocks. Support for third-party block plugins may vary.

= Will this slow down my website? =

No! The plugin is optimized for performance. It uses the native Intersection Observer API and only loads minimal JavaScript and CSS on the frontend.

= Can I customize the animation timing? =

Yes! Each block has individual controls for animation duration (0.2-2 seconds) and delay (0-1 second).

= Do animations work on mobile devices? =

Yes! Animations work smoothly across all devices and screen sizes.

= Can I disable animations on specific blocks? =

Absolutely! Simply toggle off the animation option in the block settings panel for any block you don't want to animate.

= Is this compatible with my theme? =

Yes! The plugin works with any properly coded WordPress theme that supports the block editor.

== Screenshots ==

1. Block animation settings panel in the editor
2. Animation type selection
3. Duration and delay controls
4. Plugin settings page
5. Live animation preview on frontend

== Changelog ==

= 1.0.0 =
* Initial release
* Support for 5 animation types
* Block-level animation controls
* Customizable duration and delay
* Settings page for default configuration
* Intersection Observer for scroll detection

== Upgrade Notice ==

= 1.0.0 =
Initial release of Animate Blocks. Add beautiful scroll animations to your Gutenberg blocks!

== Developer Notes ==

= Technical Details =

* Uses WordPress hooks and filters for block modification
* Leverages the Intersection Observer API for efficient scroll detection
* Adds data attributes to animated blocks for JavaScript targeting
* CSS animations with GPU acceleration for smooth performance
* Compatible with WordPress 5.8 and higher

= GitHub =

Development and issue tracking: https://github.com/valentin-grenier/animate-gut-blocks

== Credits ==

Developed by Valentin Grenier - Studio Val
