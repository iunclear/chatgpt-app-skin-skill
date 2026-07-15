---
name: codex-desktop-skinning
description: Create, customize, validate, and distribute local visual skins for Codex or ChatGPT Desktop. Use when asked to change Accent/Background/Foreground, redesign the Codex desktop UI, add a branded or themed new-task visual, create a desktop launcher, or package a skin for macOS and Windows.
---

# Codex Desktop Skinning

Create skins as a reversible local overlay. Preserve the official application bundle, account data, projects, tasks, and code signature.

## Workflow

1. Inspect the active official theme config and rendered WebView. Treat official Accent/Background/Foreground settings as the base palette only; they cannot create bespoke layouts, artwork, or sidebar treatments.
2. Locate the actual `main.main-surface`, sidebar, composer, profile row, and new-task action cards through the live Chromium DevTools Protocol (CDP). Record selectors from the running DOM, not from assumptions.
3. Build the skin in a separate directory with `theme.css`, `skin.js`, `injector.mjs`, and local assets. Use CDP `Page.addScriptToEvaluateOnNewDocument` plus periodic health checks so a page reload restores the skin.
4. Keep the visual hierarchy in layers: wide scene background at z-index 0, noninteractive foreground character/art at z-index 0 inside the scene, and native Codex controls above it. Do not place the primary visual inside a card.
5. Use original or licensed artwork. For a foreground character, generate against a flat chroma background, remove it to transparent PNG, and verify its alpha edge before compositing.
6. Limit decorative DOM changes to presentation. Never overwrite the real account, task, project, or conversation data; a display alias such as `momo` must remain a skin-only text layer.
7. Add a local launcher. On macOS, create a user-local `.app` that starts the official binary with a loopback debug port. On Windows, create a user-local PowerShell launcher and `.lnk` desktop/start-menu shortcuts. Allow explicit environment-variable overrides for app and Node paths.
8. Build a ZIP containing macOS and Windows installers, an uninstall path, local assets, a checksum, and concise user-facing instructions. Do not include runtime logs, user data, debug ports, or generated chroma-key source images.
9. Validate syntax, package contents, and an isolated install. Launch a test profile, capture the New Task page, reload it, enter a conversation, and return to New Task. Verify that the foreground visual only appears where intended and native controls remain usable.

## Core Implementation

Use this structure:

```text
skin/
  theme.css        Semantic token overrides and responsive layers
  skin.js          DOM decoration, page detection, cleanup
  injector.mjs     CDP connection, hot reload, reload persistence
  assets/          Background, transparent foreground, avatar, icons
  launch.*         Platform launcher
  doctor.*         Deterministic local checks
```

The injector must derive its directory with `fileURLToPath(import.meta.url)`, not URL pathname string slicing, so Windows paths work. Inject the bundled CSS and JavaScript as data URIs; never edit `app.asar` or bypass an application integrity check.

Prefer page-state detection from native action labels or route-specific DOM markers. Mount scene nodes once, keep cleanup handles on `window`, and remove/restore presentation mutations before reinjecting.

## Platform Packaging

Read [platform-packaging.md](references/platform-packaging.md) before creating or changing launchers. Use [validate-skin-package.sh](scripts/validate-skin-package.sh) after building a ZIP.

For a macOS smoke test, unzip the archive into a temporary directory and invoke its `.command` installer with a temporary `HOME`; verify the resulting `.app`, CLI link, and doctor script. For Windows, parse or execute the PowerShell scripts in a Windows environment; at minimum verify the ZIP contains the `.cmd`, `.ps1`, shortcut creation, uninstall, skin assets, and launcher code.

## Completion Checklist

- Official app bundle and user data untouched.
- New Task visual is visible, high-impact, and does not intercept clicks.
- Conversation view hides home-only artwork.
- Reload reinstalls the skin automatically.
- Text, composer, sidebar, and profile remain readable at desktop and narrow widths.
- macOS `.app` and Windows desktop shortcut are created by their respective installers.
- ZIP passes integrity and content validation.
- `doctor` checks required source assets and runtime syntax.
