# Bookmarklets

Readable source lives in `src/`. The generated `javascript:` URLs live in
`dist/`. They are committed, so they can be copied straight from GitHub.

To install one, create a bookmark and paste the contents of its `dist/*.txt`
file as the URL.

To rebuild after editing `src/`, run `make`. The build needs `node` and `npx`.
It fetches a pinned version of terser.
