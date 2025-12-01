import { __ } from '@wordpress/i18n';
import { addFilter } from '@wordpress/hooks';
import { createHigherOrderComponent } from '@wordpress/compose';
import { createElement, Fragment } from '@wordpress/element';
import { InspectorControls } from '@wordpress/block-editor';
import { PanelBody, ToggleControl, SelectControl, RangeControl } from '@wordpress/components';
import '../scss/editor.scss';

// Prevent multiple executions
if (!window.simpleAnimationsForGutenbergAttributesFiltersAdded) {
	window.simpleAnimationsForGutenbergAttributesFiltersAdded = true;

	/**
	 * Add animation attributes to all blocks starting with "core/"
	 */
	function addAnimationAttributes(settings, name) {
		// Only apply to core blocks
		if (!name.startsWith('core/')) {
			return settings;
		}

		return {
			...settings,
			attributes: {
				...settings.attributes,
				isAnimated: {
					type: 'boolean',
					default: false,
				},
				animationType: {
					type: 'string',
					default: 'fade-in',
				},
				animationDuration: {
					type: 'number',
					default: 0.6,
				},
				animationDelay: {
					type: 'number',
					default: 0,
				},
			},
		};
	}

	/**
	 * Add animation controls to core and meta-box blocks
	 */
	const withAnimationControls = createHigherOrderComponent((BlockEdit) => {
		return (props) => {
			const { name, attributes, setAttributes } = props;
			const { isAnimated, animationType, animationDuration, animationDelay } = attributes;

			// Only apply to core and meta-box blocks
			if (!name.startsWith('core/')) {
				return createElement(BlockEdit, props);
			}

			return createElement(
				Fragment,
				null,
				createElement(BlockEdit, props),
				createElement(
					InspectorControls,
					{ group: 'settings' },
					createElement(
						PanelBody,
						{
							title: __('Animations', 'simple_animations_for_gutenberg'),
							initialOpen: true,
						},
						createElement(ToggleControl, {
							label: __('Animer le bloc', 'simple_animations_for_gutenberg'),
							checked: isAnimated,
							onChange: (value) => {
								setAttributes({ isAnimated: value });
							},
						}),
						isAnimated &&
							createElement(SelectControl, {
								label: __("Type d'animation", 'simple_animations_for_gutenberg'),
								value: animationType,
								options: [
									{ label: __('Fondu', 'simple_animations_for_gutenberg'), value: 'fade-in' },
									{ label: __('Fondu - Bas vers haut', 'simple_animations_for_gutenberg'), value: 'fade-in-up' },
									{ label: __('Fondu - Haut vers bas', 'simple_animations_for_gutenberg'), value: 'fade-in-down' },
									{ label: __('Fondu - Gauche vers droite', 'simple_animations_for_gutenberg'), value: 'fade-in-left' },
									{ label: __('Fondu - Droite vers gauche', 'simple_animations_for_gutenberg'), value: 'fade-in-right' },
								],
								onChange: (value) => {
									setAttributes({ animationType: value });
								},
							}),
						isAnimated &&
							createElement(RangeControl, {
								label: __("Durée de l'animation", 'simple_animations_for_gutenberg'),
								value: animationDuration,
								onChange: (value) => {
									setAttributes({ animationDuration: value });
								},
								min: 0.2,
								max: 2,
								step: 0.1,
								help: __('Durée en secondes', 'simple_animations_for_gutenberg'),
							}),
						isAnimated &&
							createElement(RangeControl, {
								label: __("Délai de l'animation", 'simple_animations_for_gutenberg'),
								value: animationDelay,
								onChange: (value) => {
									setAttributes({ animationDelay: value });
								},
								min: 0,
								max: 1,
								step: 0.1,
								help: __('Durée en secondes', 'simple_animations_for_gutenberg'),
							})
					)
				)
			);
		};
	}, 'withAnimationControls');

	/**
	 * Add animation classes and styles to core and meta-box blocks
	 */
	function addAnimationClasses(props, blockType, attributes) {
		// Only apply to core and meta-box blocks
		if (!blockType.name.startsWith('core/') && !blockType.name.startsWith('meta-box/')) {
			return props;
		}

		const { isAnimated, animationType, animationDuration, animationDelay } = attributes;

		if (isAnimated) {
			const animationClass = `animate-${animationType}`;

			return {
				...props,
				className: props.className ? `${props.className} ${animationClass}` : animationClass,
				style: {
					...props.style,
					'--animation-duration': `${animationDuration}s`,
					'--animation-delay': `${animationDelay}s`,
				},
			};
		}

		return props;
	}

	// Apply filters
	addFilter('blocks.registerBlockType', 'simple_animations_for_gutenberg/animation-attributes', addAnimationAttributes);
	addFilter('editor.BlockEdit', 'simple_animations_for_gutenberg/with-animation-controls', withAnimationControls);
	addFilter('blocks.getSaveContent.extraProps', 'simple_animations_for_gutenberg/add-animation-classes', addAnimationClasses);
}
