// Flip the page between dark and light.
//
// Some sites only offer a dark mode. Inverting the whole page derives a light
// mode from it. The 180° hue rotation brings colors back to roughly their
// original hue. It works in both directions. A second click restores the page.
//
// Images, video, canvases and iframes get the same filter again. Inverting
// twice cancels out, so they keep their original colors. A picture element
// is left out because it wraps an img, which is already covered. CSS
// background images stay inverted, which keeps text over them legible.
//
// The rules live in a style element, so the page's own inline styles are not
// touched. Removing the element restores the page.
//
// Possible problems, not yet seen in practice:
//
//   - A site may set its own filter on images, such as a grayscale hover. That
//     rule can win over ours, and those images stay inverted. Adding
//     !important to the media rule would fix it.
//   - A page may never set a background color. The area outside its content
//     may then stay white. Adding background:#fff to the html rule should fix
//     it.
//   - Very saturated colors in media may shift slightly. The browser clips
//     colors between the two inversions, so they do not cancel out exactly.
//     A filter cannot fix this.

const id = 'r-flip';
const existing = document.getElementById(id);

if (existing) {
  existing.remove();
} else {
  const filter = 'filter:invert(100%) hue-rotate(180deg)';
  const style = document.createElement('style');
  style.id = id;
  style.textContent =
    'html{' + filter + '}' +
    'img,video,canvas,iframe,svg image{' + filter + '}';
  (document.head || document.documentElement).appendChild(style);
}
