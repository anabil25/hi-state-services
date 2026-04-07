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
        ├── deploy.yml       # GitHub Pages deployment
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

## What Makes This Demo Compelling for Hawaii ETS

This site mirrors the types of content and patterns their actual WordPress-based state theme uses:

- **Multi-department structure** — scanner works across pages, not just one
- **Government forms** — PDF download links, form downloads
- **Data tables** — program info, fee schedules, department directories
- **Contact forms** — common on every government site
- **News/announcements** — blog posts with dates (triggers the `<time>` contrast issue from the original demo)
- **Multi-language references** — realistic for Hawaii's diverse population
- **Emergency preparedness** — typical government content type
- **Deep linking** — anchor links between pages (services ↔ departments ↔ forms)

## Setup Instructions

### 1. Create a GitHub Repository

1. Create a new **public** repo (e.g., `a11y-scanner-demo`) on GitHub
2. Push this code to it:
   ```bash
   git init
   git add .
   git commit -m "Initial commit: demo site with accessibility issues"
   git remote add origin https://github.com/YOUR_USERNAME/a11y-scanner-demo.git
   git push -u origin main
   ```

### 2. Enable GitHub Pages

1. Go to **Settings → Pages**
2. Under "Build and deployment", select **GitHub Actions** as the source
3. The deploy workflow will run automatically on push
4. Your site will be live at `https://YOUR_USERNAME.github.io/a11y-scanner-demo/`

### 3. Configure the Accessibility Scanner

1. **Create a Fine-Grained PAT** at [github.com/settings/tokens](https://github.com/settings/tokens?type=beta) with these permissions on your repo:
   - `actions: write`
   - `contents: write`
   - `issues: write`
   - `pull-requests: write`
   - `metadata: read`

2. **Add the PAT as a repository secret:**
   - Go to **Settings → Secrets and variables → Actions**
   - Create a secret named `GH_TOKEN` with your PAT value

3. **Update the workflow file** (`.github/workflows/a11y-scan.yml`):
   - Replace `REPLACE_WITH_GITHUB_PAGES_URL` with your GitHub Pages URL
   - Replace `REPLACE_WITH_OWNER/a11y-scanner-demo` with your actual `owner/repo`

### 4. Run the Scanner

1. Go to **Actions → Accessibility Scanner**
2. Click **Run workflow**
3. The scanner will create GitHub Issues for each accessibility violation found
4. Issues are automatically assigned to **GitHub Copilot**, which will propose fixes via PRs
5. Review and merge the PRs!

## Demo Flow

1. Show the live site with accessibility issues
2. Trigger the scanner workflow
3. Show the issues created automatically with detailed descriptions
4. Show Copilot proposing code fixes in PRs
5. Review and merge a fix, show the site is improved

## Tech Stack

- **Site:** Jekyll + Minima theme
- **Hosting:** GitHub Pages
- **Scanner:** [github/accessibility-scanner](https://github.com/github/accessibility-scanner) v3
- **Fixes:** GitHub Copilot coding agent
