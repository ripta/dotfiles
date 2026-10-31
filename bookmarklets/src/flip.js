// Flip the page between dark and light.
//
// Some sites only offer a dark mode. Inverting the whole page derives a light
// mode from it. The 180° hue rotation brings colors back to roughly their
// original hue. It works in both directions. A second click restores the page.
//
// Known side effect: images and video are inverted too.

document.documentElement.style.filter = document.documentElement.style.filter
  ? ''
  : 'invert(100%) hue-rotate(180deg)';
