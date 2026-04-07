# Hawaii State Services — Accessibility Scanner Demo

A realistic multi-page Hawaii state government website with intentional accessibility issues, designed to demo the [GitHub Accessibility Scanner](https://github.com/github/accessibility-scanner) and GitHub Copilot's ability to automatically detect and fix WCAG violations.

## Site Structure

```
├── _layouts/
│   ├── default.html        # Base layout (header, footer, meta)
│   ├── home.html           # Homepage layout
│   ├── page.html           # Standard page layout
│   └── post.html           # Blog post layout
├── _includes/
│   ├── header.html         # Site header with nav
│   └── footer.html         # Site footer
├── _posts/
│   ├── 2026-03-15-new-benefits-portal.html
│   ├── 2026-03-28-medicaid-renewal-deadline.html
│   ├── 2026-04-01-hurricane-preparedness.html
│   └── 2026-04-05-state-job-fair.html
├── assets/css/style.css    # Site stylesheet
├── index.html              # Homepage (hero, services grid, stats, news)
├── services.html           # Services directory (benefits, health, employment, housing, education, licensing)
├── departments.html        # Department directory with contact info
├── forms.html              # Downloadable forms and applications
├── about.html              # About page, offices, contact form
├── 404.html                # Error page
├── _config.yml             # Jekyll configuration
└── .github/
    ├── copilot-instructions.md
    └── workflows/
        ├── deploy.yml       # Azure Static Web Apps deployment
        └── a11y-scan.yml    # Accessibility Scanner
```

## Intentional Accessibility Issues

These are spread across the site to demonstrate the scanner finding real-world government website issues:

| Category | Issues | Pages Affected |
|----------|--------|----------------|
| **Color Contrast** | Low contrast text on backgrounds (hero, buttons, nav links, cards, footer links, stats) | All pages |
| **Missing Alt Text** | Images without alt attributes (icons, banners, screenshots, logos) | Homepage, Services, Forms, Posts |
| **Missing Form Labels** | Inputs with placeholder text but no `<label>` elements | About (contact form), Homepage (search), Forms (filters), Posts (alert signup) |
| **Empty Links** | Links with no text content (TTY links, image-only links) | Header, About, Departments, Forms |
| **Empty href** | Links with `href=""` (various apply/download buttons) | Homepage, Services, Forms |
| **Marquee Element** | Non-accessible scrolling text for announcements | Homepage |
| **Heading Hierarchy** | Skipped heading levels (h1→h4, h6 used incorrectly) | Homepage, Services, Departments |
| **Table Headers** | Tables using `<td><strong>` instead of `<th scope>` | All pages with tables |
| **Reflow/Overflow** | Fixed-width elements wider than viewport (1200px banners) | Homepage, Departments, 404 |
| **Tabindex on Non-interactive** | `tabindex="0"` on presentation divs | About |
| **JavaScript Links** | `onclick` handlers instead of proper hrefs | Services, Forms, Posts |

## What Makes This Compelling 

- **Multi-department structure** — scanner works across pages, not just one
- **Government forms** — PDF download links, form downloads
- **Data tables** — program info, fee schedules, department directories
- **Contact forms** — common on every government site
- **News/announcements** — blog posts with dates (triggers the `<time>` contrast issue from the original demo)
- **Multi-language references** — realistic for Hawaii's diverse population
- **Emergency preparedness** — typical government content type
- **Deep linking** — anchor links between pages (services ↔ departments ↔ forms)

## Tech Stack

- **Site:** Jekyll (custom layouts, no theme dependency)
- **Hosting:** Azure Static Web Apps (Free tier)
- **Infra:** Bicep (deploys SWA resource)
- **Scanner:** [github/accessibility-scanner](https://github.com/github/accessibility-scanner) v3
- **Fixes:** GitHub Copilot coding agent
