import '../scss/frontend.scss';

// Only the blocks animated by the plugin: SIMPBLAN_Blocks adds both the class and
// the matching data attribute at render time. Keep the list in sync with
// SIMPBLAN_Blocks::get_animation_types().
const TYPES = [
	'fade-in',
	'fade-in-up',
	'fade-in-down',
	'fade-in-left',
	'fade-in-right',
	'zoom-in',
	'slide-up',
];
const SELECTOR = TYPES.map(
	( type ) => `.animate-${ type }[data-animation="${ type }"]`
).join( ',' );

// Tells the inline head script that this file runs and can reveal the blocks.
// Without the flag, that script removes the hidden initial state on window load.
const isSupported = 'IntersectionObserver' in window;
if ( isSupported ) {
	window.simpblanReady = true;
}

function initAnimations() {
	if ( ! isSupported ) {
		return;
	}

	const animatedBlocks = document.querySelectorAll( SELECTOR );
	if ( ! animatedBlocks.length ) {
		return;
	}

	const observerOptions = {
		threshold: 0.1,
		rootMargin: '0px 0px -50px 0px',
	};

	const observer = new IntersectionObserver( ( entries ) => {
		entries.forEach( ( entry ) => {
			if ( entry.isIntersecting ) {
				entry.target.classList.add( 'is-visible' );
				observer.unobserve( entry.target );
			}
		} );
	}, observerOptions );

	animatedBlocks.forEach( ( block ) => {
		observer.observe( block );
	} );
}

// The script is enqueued while blocks render, so DOMContentLoaded may already be past.
if ( document.readyState === 'loading' ) {
	document.addEventListener( 'DOMContentLoaded', initAnimations );
} else {
	initAnimations();
}
