// Reload the page without its query string or fragment.
//
// Tracking parameters and other clutter often ride along in a URL. This keeps
// only the origin and path, so the clean URL can be shared or bookmarked.

window.location = window.location.origin + window.location.pathname;
