import '../scss/frontend.scss';

document.addEventListener('DOMContentLoaded', () => {
	const animatedBlocks = document.querySelectorAll('[class*="animate-"]');
	if (!animatedBlocks.length) return;

	const observerOptions = {
		threshold: 0.1,
		rootMargin: '0px 0px -50px 0px',
	};

	const observer = new IntersectionObserver((entries) => {
		entries.forEach((entry) => {
			if (entry.isIntersecting) {
				entry.target.classList.add('is-visible');
				observer.unobserve(entry.target);
			}
		});
	}, observerOptions);

	animatedBlocks.forEach((block) => {
		observer.observe(block);
	});
});
