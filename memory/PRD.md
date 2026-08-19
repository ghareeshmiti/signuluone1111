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

## Implemented — 2026-06 (iteration 3)
- Crawled the customer's seven live industry pages (manufacturing, banking-financial-services,
  professionalservices, realestate, healthcare, law, it) and rebuilt them in the unified theme
  from a single generator template, so every sector page is structurally identical:
  `banking-and-financial-services`, `real-estate`, `professional-services`, `manufacturing`,
  `healthcare`, `legal-services`, `information-technology`.
- Each page: hero with breadcrumb + Start free trial / Book a demo, intro with sector imagery,
  benefits grid (real copy from the source pages), use-case list, "Summary of Signulu benefits"
  band, and the 14-day / 5-free-documents CTA.
- Industries mega-menu, `/industries.html` grid, home sector tiles and the footer column now
  cover all seven sectors.
- Verified by testing agent (`test_reports/iteration_3.json`): all pass, no bugs — theme tokens
  identical across pages, all links resolve, no overflow at 375/768/1440, pricing/trial/estimator
  regressions clean.

## Implemented — 2026-06 (iteration 2)
- **SignuluOne theme adopted from signuluone.com**: violet `#5A30F1` primary/action, gold
  `#FFD15D` hero highlight and on-dark accent, `#F9FBFD` light sections, `#2C2F36` dark
  surface/footer, `#333` headings, Lato typography, 8px cards. All navy/blue removed.
- **Brand**: official SignuluOne logo (`img/signuluone-logo.png`) in header, footer and favicon;
  name changed to SignuluOne across titles and brand marks.
- **Our Signulu Solutions**: new `solutions.html` plus nav mega-menu and home section for the
  three products, each redirecting to its own URL (Signing Solutions →
  signulu.com/index.php/about, Signulu DMS → signuluone.com/Dms.html, DSC BulkSigner →
  bulksigner.signuluone.com). `products.html` is now a redirect stub.
- **Per-product pricing**: `pricing.html` has product tabs with three distinct plan sets
  (eSignature $12/$29/Custom, DMS $15/$35/Custom, BulkSigner $19/$49/Custom), each card
  offering Start free trial and Book a demo.
- **Free trial gate**: `partials/trial-modal.html` asks which product, then redirects based on
  the selection (validation error if nothing is chosen).
- **Book a demo with product selection**: contact form has a required product select that
  pre-fills from `?product=` (and `?intent=trial` prefills the message).
- **Log in removed** everywhere.
- **Hosting**: `yarn start` now serves `frontend/public` with `python -m http.server` — the CRA
  dev server was injecting a bundle/error overlay and caching a stale `index.html`.
- Verified by testing agent (`test_reports/iteration_2.json`): 100% frontend pass — theme
  identical on all 12 pages, trial redirects correct, pricing tabs distinct, contact prefill and
  validation working, no login remnants, no overflow at 375/768/1440.

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
