# Simple block animations

A lightweight WordPress plugin that brings your Gutenberg editor to life by adding beautiful scroll-triggered animations to any block.

![WordPress Plugin Version](https://img.shields.io/wordpress/plugin/v/simple-block-animations.svg)
![WordPress Compatibility](https://img.shields.io/badge/wordpress-6.2%2B-blue.svg)
![PHP Version](https://img.shields.io/badge/php-7.4%2B-purple.svg)
![License](https://img.shields.io/badge/license-GPLv2%2B-green.svg)

## Description

Simple block animations is perfect for creating engaging, modern websites with minimal effort. Add smooth scroll animations to your Gutenberg blocks without writing a single line of code.

## Key Features

* **No Coding Required** - Add animations directly from the block inspector panel
* **Multiple Animation Types** - Choose from fade in, fade in up/down/left/right, zoom in and slide up effects
* **Customizable Settings** - Control animation duration and delay for each block
* **Scroll Trigger** - Animations activate when blocks enter the viewport
* **Performance Optimized** - Lightweight JavaScript with Intersection Observer API
* **Universal Block Support** - Compatible with all WordPress blocks (core, third-party, and custom blocks)
* **Block-Level Control** - Enable/disable animations per block

## Supported Animation Types

* Fade In
* Fade In Up (slide from bottom)
* Fade In Down (slide from top)
* Fade In Left (slide from left)
* Fade In Right (slide from right)
* Zoom In
* Slide Up

## Installation

### Manual Installation

1. Download the plugin ZIP file
2. Log in to your WordPress admin panel
3. Navigate to **Plugins > Add New > Upload Plugin**
4. Choose the downloaded ZIP file and click "Install Now"
5. Activate the plugin

### For Development

1. Clone this repository into your WordPress plugins directory:

   ```bash
   cd wp-content/plugins
   git clone https://github.com/valentin-grenier/simple-block-animations.git
   ```

2. Install dependencies:

   ```bash
   cd simple-block-animations
   composer install
   npm install
   ```

3. Build assets:

   ```bash
   npm run build
   ```

4. Activate the plugin from the WordPress admin panel

## Usage

1. Go to **Settings > Block Animations** to configure default options
2. Edit any post or page with the Gutenberg editor
3. Select a block and enable animations from the block settings panel
4. Choose your preferred animation type
5. Adjust duration and delay (optional)
6. Publish and watch your blocks come to life!

## For Developers: Setting Default Animations in Custom Blocks

You can configure custom blocks to have animations enabled by default by adding animation attributes to your block's `block.json` file:

```json
{
  "attributes": {
    "isAnimated": {
      "type": "boolean",
      "default": true
    },
    "animationType": {
      "type": "string",
      "default": "fade-in-up"
    },
    "animationDuration": {
      "type": "number",
      "default": 0.8
    },
    "animationDelay": {
      "type": "number",
      "default": 0.2
    }
  }
}
```

**Available animation types:**
- `fade-in`
- `fade-in-up`
- `fade-in-down`
- `fade-in-left`
- `fade-in-right`
- `zoom-in`
- `slide-up`

When these attributes are defined in your block.json, the Simple Block Animations plugin will respect them and automatically enable animations with your specified defaults when the block is inserted. This saves developers from having to manually configure animations for each block instance.

## How It Works

The plugin uses the modern Intersection Observer API to detect when blocks enter the viewport, ensuring smooth performance even on content-heavy pages. It adds an animation class, CSS custom properties and a `data-animation` attribute to animated blocks, then plays CSS transitions on `opacity` and `transform`. Visitors who ask for reduced motion (`prefers-reduced-motion`) see the content without animation.

## Perfect For

* Landing pages
* Portfolio websites
* Marketing sites
* Blog posts with visual flair
* Any site that wants to add subtle motion

## FAQ

### Does this plugin work with all blocks?

Yes. The plugin works with all WordPress blocks, including core blocks, third-party blocks, and custom blocks.

### Will this slow down my website?

No! The plugin is optimized for performance. It uses the native Intersection Observer API, and the frontend script and stylesheet are only enqueued on pages that render an animated block.

### Can I customize the animation timing?

Yes! Each block has individual controls for animation duration (0.2-2 seconds) and delay (0-1 second).

### Do animations work on mobile devices?

Yes! Animations work smoothly across all devices and screen sizes.

### Can I disable animations on specific blocks?

Absolutely! Simply toggle off the animation option in the block settings panel for any block you don't want to animate.

### Is this compatible with my theme?

Yes! The plugin works with any properly coded WordPress theme that supports the block editor.

### Does this work with dynamic/server-side rendered blocks?

Yes! The plugin automatically handles animations for all blocks, including custom blocks with PHP rendering (render_callback). No additional code is required.

## Technical Details

* Uses WordPress hooks and filters for block modification
* Leverages the Intersection Observer API for efficient scroll detection
* Automatically adds animation classes, styles, and data attributes to all blocks
* CSS transitions on `opacity` and `transform`
* Compatible with WordPress 6.2 and higher (uses `WP_HTML_Tag_Processor`)
* Works seamlessly with dynamic blocks via the render_block filter

## Development

### Requirements

* WordPress 6.2 or higher
* PHP 7.4 or higher
* Node.js and npm
* Composer

### Building

```bash
# Install dependencies
npm install
composer install

# Build for production
npm run build

# Build for development (watch mode, with source maps)
npm run dev

# Lint JavaScript and styles
npm run lint:js
npm run lint:css
```

### Code Standards

This plugin follows WordPress coding standards. Check your code with:

```bash
# PHP CodeSniffer
composer phpcs

# Auto-fix issues
composer phpcbf
```

## Changelog

See the `== Changelog ==` section of [readme.txt](readme.txt).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the GPLv2 or later - see the [LICENSE](LICENSE) file for details.

## Credits

Developed by [Valentin Grenier](https://github.com/valentin-grenier) - [Studio Val](https://studio-val.fr)

## Support

For issues, questions, or suggestions, please [open an issue](https://github.com/valentin-grenier/simple-block-animations/issues) on GitHub.
