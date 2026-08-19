# Signulu Website

Static, multi-page marketing site for Signulu (electronic signatures). Plain HTML5 +
Bootstrap 5 + Bootstrap Icons + vanilla CSS/JS. **No build step, no framework.**

## Structure

```
frontend/public/
├── index.html                              # visual source of truth (home)
├── solutions.html                          # Our Signulu Solutions (3 products)
├── industries.html
├── banking-and-financial-services.html
├── real-estate.html
├── professional-services.html
├── pricing.html                            # tabbed pricing per product
├── blog.html
├── contact.html                            # book a demo, with product selection
├── privacy-policy.html
├── terms-of-service.html
├── 404.html
├── img/signuluone-logo.png                 # official SignuluOne logo (brand + favicon)
├── css/
│   ├── tokens.css                          # design tokens (CSS variables) + Bootstrap var overrides
│   └── theme.css                           # component styles built on the tokens
├── js/
│   └── include.js                           # fetches partials, active nav, reveal, trial-modal redirect
├── partials/
│   ├── header.html                          # nav + mega-menus (one source of truth, no login)
│   ├── footer.html
│   ├── product-modal.html                   # solution picker (demo / visit product site)
│   └── trial-modal.html                     # free-trial product gate
├── products.html                            # redirect stub -> solutions.html
└── "Old Spaced Name.html"                   # redirect stubs -> kebab-case URLs
```

## Brand & theme (from signuluone.com)

| Token | Value |
| --- | --- |
| Primary / action | `#5A30F1` (violet) |
| Hero highlight & on-dark accent | `#FFD15D` (gold) |
| Light section surface | `#F9FBFD` |
| Dark surface / footer | `#2C2F36` |
| Headings | `#333333` |
| Body text / muted | `#555555` / `#6B7280` |
| Font | Lato (fallback Segoe UI) |
| Card radius / shadow | 8px, `0 5px 15px rgba(0,0,0,.03)` |

## Solutions and where they point

| Solution | Destination |
| --- | --- |
| Signulu Signing Solutions | https://signulu.com/index.php/about |
| Signulu Document Management System | https://www.signuluone.com/Dms.html |
| DSC BulkSigner | https://bulksigner.signuluone.com/ |

"Start free trial" opens `#trialModal`, asks which product, then redirects to that
product's trial destination (eSignature goes to https://app.signulu.com/account/register).
"Book a demo" goes to `/contact.html#demo`, which accepts `?product=esignature|dms|bulksigner`
(and `&intent=trial`) to pre-select the product on the form.

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

In this workspace `yarn start` (in `frontend/`) does exactly that — it serves
`frontend/public` on `$PORT`. There is no React runtime and no build step.

Then open http://localhost:3000. `fetch()` needs HTTP — opening the files with `file://`
will not load the partials.

## Deployment

Publish the contents of `frontend/public/` as-is to any static host or CDN. Nothing is compiled.

## Conventions

- Filenames are kebab-case; legacy spaced filenames remain as redirect stubs.
- Every page sets `<title>`, `<meta name="description">`, `<link rel="canonical">` and the favicon.
- Interactive elements carry `data-testid` attributes for automated tests.
