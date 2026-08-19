# Signulu Website — PRD

## Original problem statement
Make every page of the Signulu static multi-page site visually and structurally consistent
with `index.html` (colors, typography, nav, footer, spacing, components). No rebuild, no
framework change. Stop the `fix-*.ps1` regex-patching pattern; centralize instead:
`css/tokens.css` + `css/theme.css` + JS-injected header/footer/modal partials. Sweep all
pages, kebab-case filenames with redirects, delete `pricing copy.html` and `fix-*.ps1`,
fill in README, then verify (visual diff, broken links, 375/768/1440, Lighthouse basics).

### Approved decisions (user, June 2026)
- Yes to `js/include.js` partials + `tokens.css`/`theme.css` single source of truth.
- Yes to kebab-case renames **with** old-name redirect stubs.
- Yes to deleting `pricing copy.html` and all `fix-*.ps1`.
- No pages off-limits.

### Important context
The original ~20 HTML pages were **not present in the workspace** and `signulu.com` serves
only a login page, so the unified site was authored fresh (same stack, same brand facts:
gold `#FFD15D` accent on dark hero, deep navy primary, Bootstrap 5) and is now the source
of truth. If the original files are supplied later, content can be ported page-by-page into
the existing structure without touching the design system.

## Architecture
- Pure static site in `/app/frontend/public`, served at the preview root by the frontend
  supervisor process. No build step, no backend, React runtime intentionally disabled
  (`/app/frontend/src/index.js` is a comment only).
- `css/tokens.css` — CSS variables for colors/type/spacing/radii/shadows **and** Bootstrap 5
  variable overrides so `text-primary`, `bg-*`, borders inherit the brand.
- `css/theme.css` — component styles (section rhythm, hero, buttons, cards, mega-menu,
  pricing, blog, forms, footer, legal prose, reveal animation).
- `partials/header.html`, `partials/footer.html`, `partials/product-modal.html` — edited once.
- `js/include.js` — fetches partials into `[data-include]`/`[data-modal]`, sets the active nav
  from `<body data-page>`, runs the scroll reveal.

## User personas
- **Ops/legal owner** — needs contracts signed fast with defensible evidence.
- **Industry buyer** (banking, real estate, professional services) — needs sector proof.
- **Developer** — needs API/webhook detail.
- **Site maintainer** — needs to change nav/footer/theme in one place.

## Core requirements (static)
1. One design system; zero per-page hex codes or inline `<style>` blocks.
2. Shared nav/footer/modal markup.
3. Consistent `section > .container > .row` rhythm, heading and button classes.
4. Normalized `<title>`, meta description, canonical, favicon per page.
5. kebab-case URLs, legacy names redirect.
6. `data-testid` on interactive/critical elements.

## Implemented — 2026-06 (iteration 1)
- Phase 1: `css/tokens.css`, `css/theme.css` (Outfit/Manrope, navy + gold, 5rem rhythm).
- Phase 2: three partials + `js/include.js` (active nav, reveal, cached fetch).
- Phase 3: 12 pages built on the system — `index`, `products`, `industries`,
  `banking-and-financial-services`, `real-estate`, `professional-services`, `pricing`,
  `blog`, `contact`, `privacy-policy`, `terms-of-service`, `404`.
- Phase 4: kebab-case filenames + 6 redirect stubs for legacy spaced names; "Terms of
  Services" corrected to "Terms of Service"; `README.md` documents structure, local run and
  the partials pattern.
- Phase 5 (verified by testing agent, `test_reports/iteration_1.json`): computed styles
  identical across all 12 pages (nav 76px, body Manrope, h1 Outfit 56px, footer
  `rgb(6,22,38)`, section padding 80/80); all internal links and in-page anchors 200/resolve;
  redirects work; mega-menus, modal, FAQ accordion and contact validation work; 375/768/1440
  clean after fixing a 12px gutter overflow centrally in `theme.css`.

## Backlog
### P0
- Port real Signulu copy/pages if the original HTML is supplied (content only; structure stays).
### P1
- Individual blog article template + real posts (blog is a listing of placeholder cards).
- Wire the contact/demo form to a real endpoint (currently client-side only, MOCKED).
- Lighthouse pass with the CRA dev bundle removed (host `public/` directly).
### P2
- Self-host fonts and Bootstrap to drop CDN dependency.
- `sitemap.xml`, `robots.txt`, Open Graph/Twitter cards, JSON-LD Organization schema.
- Server-level 301s for legacy spaced URLs (meta-refresh stubs are a client-side stand-in).

## Next tasks
1. Drop in original page copy where it exists.
2. Blog article detail template.
3. Real form submission target.
4. SEO extras (sitemap, OG tags, structured data).
