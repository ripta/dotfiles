// Open the page's Open Graph image.
//
// Many pages name a preview image in an og:image meta tag. This navigates
// to the first such image. A page without one gets an alert instead.

const meta = document.querySelector('meta[property="og:image"]');

if (meta) {
  window.location = meta.getAttribute('content');
} else {
  alert('Page has no og:image attribute to redirect to.');
}
