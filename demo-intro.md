## Intro

I'm a solutions engineer — my job is to help our customers find the best ways to use AI. It's a collaborative process where we start by identifying real  needs, then work together to show we can deliver value.

---

## Set the Scene

So Jen mentioned the ADA compliance deadline coming up — let me give you the quick context on why this matters right now.

Last April, the DOJ finalized a rule under **ADA Title II** that for the first time sets a hard technical standard for government websites: That's 50 specific criteria — things like color contrast ratios, keyboard navigation, form labels, and so on.

The deadline for entities your size is **April 24, 2026** — that's in 17 days. Non-compliance opens the door to DOJ complaints, private lawsuits, and civil penalties up to $150,000.

---

## The Problem 

1. **Manual audit** — hire consultants ($50K–$200K) to crawl every page with screen readers and contrast checkers
2. **Spreadsheet of findings** — hundreds of issues across dozens of pages, documented in a report
3. **Developer triage** — engineers manually interpret each finding, look up WCAG rules, write fixes
4. **Re-test** — pay for another audit to verify each fix
5. **Repeat** — new content breaks accessibility, start over next quarter
---

## What We're Going to Show You

Since you've already procured GitHub Copilot licenses, there's a tool in the GitHub Marketplace called the **Accessibility Scanner** that plugs directly into that workflow.

## let me share my sceen and show you how it works##




**First**, the scanner runs as a GitHub Action against your live site. It uses axe-core and Playwright under the hood — same engine as most professional audit tools — and scans every page you point it at. For each violation it finds, it automatically creates a GitHub Issue with the exact HTML element, the WCAG rule it violates, a screenshot, and specific guidance on how to fix it.

**Second** — and this is the part that changes everything — each issue gets assigned to GitHub Copilot. Copilot reads the issue, looks at your codebase, understands your coding standards from instructions you provide, and opens a Pull Request with the actual code fix. Not a recommendation — working code.

**Third**, your team reviews the PR and merges it. Human in the loop, always. Copilot does the heavy lifting, your developers make the final call.

**Then you run the scanner again.** Anything Copilot missed or new issues from the fixes get caught in the next cycle. And because it's a GitHub Action, you can run it on every push — continuous compliance, not a one-time audit.

What used to take months now takes days. And it stays compliant as content changes.

---

## Live Demo

Let me show you this in action. I built a demo site that mirrors a Hawaii state services portal — departments, forms, benefits pages, news posts — the kind of content your sites have.

| | |
|---|---|
| **Original site (with issues)** | https://brave-desert-05052540f.1.azurestaticapps.net |
| **Fixed site (after Copilot)** | https://black-mud-081305f0f.7.azurestaticapps.net |
| **GitHub repo** | https://github.com/anabil25/hi-state-services |

### Demo flow
1. Show the original site — looks fine visually, but the scanner found **39 accessibility violations**
2. Show the issues the scanner created — each one has the element, the rule, a screenshot, and fix guidance
3. Show Copilot's PRs — actual code changes, not just recommendations
4. Review and merge a fix live on the call
5. Show the fixed site — same design, now accessible

---

## Close

The point here isn't that AI replaces your developers or your Siteimprove workflow. It's that it closes the gap between "we found the issues" and "we shipped the fixes." Your team reviews everything. And because it runs in GitHub where your State Theme already lives, there's no new tooling to adopt — just an Action in your existing repo.

If this is useful, Kennedy and I can work with your team and Tyler Hawaii to set this up against the actual State Theme repo. Happy to do a short pilot.

