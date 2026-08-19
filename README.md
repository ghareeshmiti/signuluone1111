# Signulu Website

Static, multi-page marketing site for Signulu (electronic signatures). Plain HTML5 +
Bootstrap 5 + Bootstrap Icons + vanilla CSS/JS. **No build step, no framework.**

## Structure

```
frontend/public/
├── index.html                              # visual source of truth (home)
├── products.html
├── industries.html
├── banking-and-financial-services.html
├── real-estate.html
├── professional-services.html
├── pricing.html
├── blog.html
├── contact.html
├── privacy-policy.html
├── terms-of-service.html
├── 404.html
├── css/
│   ├── tokens.css                          # design tokens (CSS variables) + Bootstrap var overrides
│   └── theme.css                           # component styles built on the tokens
├── js/
│   └── include.js                           # fetches partials, sets active nav, reveal animation
├── partials/
│   ├── header.html                          # nav + mega-menus (one source of truth)
│   ├── footer.html
│   └── product-modal.html
├── favicon.svg
└── "Old Spaced Name.html"                   # redirect stubs -> kebab-case URLs
```

## How the design system works

`css/tokens.css` holds every value (colors, type scale, spacing, radii, shadows) as CSS
variables and also overrides Bootstrap 5 variables (`--bs-primary`, `--bs-body-font-family`,
…) so native utilities like `text-primary` inherit the brand automatically.

`css/theme.css` styles components on top of those tokens: buttons, cards, hero, mega-menu,
pricing, footer, legal prose, section rhythm.

Rules for new pages:

1. Link `tokens.css` then `theme.css` (page-specific CSS only if unavoidable).
2. No inline `<style>` blocks and no hard-coded hex colors — use `var(--sg-*)`.
3. Use `section` → `.container` → `.row` wrappers with the `.section` / `.section-alt` /
   `.section-dark` rhythm classes.
4. Buttons: `btn btn-gold` (primary action), `btn btn-outline-primary`, `btn btn-outline-light`
   on dark backgrounds.

## How partials work

Each page contains only placeholders:

```html
<header class="site-header" data-include="/partials/header.html"></header>
<footer class="site-footer" data-include="/partials/footer.html"></footer>
<div data-modal="/partials/product-modal.html"></div>
...
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/js/include.js"></script>
```

`js/include.js` fetches each partial, injects it, then highlights the current nav item
using `<body data-page="…">` (or a filename match) and runs the scroll reveal.
Bootstrap's dropdown/modal data-API is delegated, so injected markup works without extra wiring.

Edit the nav or footer **once** in `partials/` — every page updates.

## Running locally

Any static server works, e.g. from `frontend/public`:

```bash
python3 -m http.server 3000
```

Then open http://localhost:3000. `fetch()` needs HTTP — opening the files with `file://`
will not load the partials.

## Deployment

Publish the contents of `frontend/public/` as-is to any static host or CDN. Nothing is compiled.

## Conventions

- Filenames are kebab-case; legacy spaced filenames remain as redirect stubs.
- Every page sets `<title>`, `<meta name="description">`, `<link rel="canonical">` and the favicon.
- Interactive elements carry `data-testid` attributes for automated tests.
