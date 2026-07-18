---
name: codex-desktop-skinning
description: Create, customize, validate, and distribute local dynamic skins for Codex or ChatGPT Desktop. Use when asked to change Accent/Background/Foreground, redesign the Codex desktop UI, add animated backgrounds, or switch static and dynamic skins in-app without restarting.
---

# Codex Desktop Skinning

Create skins as a reversible local overlay. Preserve the official application bundle, account data, projects, tasks, and code signature. Default to a **Dynamic Skin Studio**, not a single static theme: a live in-app switcher must let people preview and change every shipped static and dynamic skin without quitting ChatGPT/Codex.

## Workflow

1. Inspect the active official theme config and rendered WebView. Treat official Accent/Background/Foreground settings as the base palette only; they cannot create bespoke layouts, artwork, or sidebar treatments.
2. Locate the actual `main.main-surface`, sidebar, composer, profile row, and new-task action cards through the live Chromium DevTools Protocol (CDP). Record selectors from the running DOM, not from assumptions.
3. Build the skin in a separate directory with `theme.css`, `skin.js`, `injector.mjs`, and local assets. Use CDP `Page.addScriptToEvaluateOnNewDocument` plus periodic health checks so a page reload restores the skin.
4. Define a small in-memory skin registry in `skin.js`: each entry has a stable id, name, static/dynamic badge, preview, token set, and motion profile. Mount a non-modal `皮肤` button in the live WebView. Choosing an entry must update `document.documentElement.dataset` immediately, persist the id to localStorage, and never reload or relaunch the app.
5. Build motion as composited CSS layers (gradients, transforms, opacity, pseudo-elements) behind native controls. Provide at least one still skin and three materially distinct motion languages, for example: image drift/lantern light, fluid aurora, and orbital starfield. Do not fake variety by only recoloring the same animation.
6. Include a `动效：全开 / 省电` control. Honor `prefers-reduced-motion`, pause nonessential work when the page is hidden, avoid network-loaded animation assets and unbounded Canvas loops, and ensure animations use only `transform`/`opacity` where practical.
7. Keep the visual hierarchy in layers: wide scene background at z-index 0, noninteractive foreground character/art at z-index 0 inside the scene, and native Codex controls above it. Do not place the primary visual inside a card.
8. Use original or licensed artwork. For a foreground character, generate against a flat chroma background, remove it to transparent PNG, and verify its alpha edge before compositing.
9. Limit decorative DOM changes to presentation. Never overwrite the real account, task, project, or conversation data; a display alias such as `momo` must remain a skin-only text layer.
10. Add a local launcher. On macOS, create a user-local `.app` that starts the official binary with a loopback debug port. On Windows, create a user-local PowerShell launcher and `.lnk` desktop/start-menu shortcuts. Allow explicit environment-variable overrides for app and Node paths.
11. Build a ZIP containing macOS and Windows installers, an uninstall path, local assets, a checksum, and concise user-facing instructions. Do not include runtime logs, user data, debug ports, or generated chroma-key source images.
12. Validate syntax, package contents, and an isolated install. Launch a test profile, capture the New Task page, switch from static to every dynamic skin and back, reload it, enter a conversation, and return to New Task. Verify the selected skin restores after reload, native controls remain usable, and reduced-motion mode pauses all decorative animation.

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

Read [dynamic-skin-studio.md](references/dynamic-skin-studio.md) before implementing a switcher. The switcher is presentation-only: it must not alter real account, task, project, conversation, or server state.

## Platform Packaging

Read [platform-packaging.md](references/platform-packaging.md) before creating or changing launchers. Use [validate-skin-package.sh](scripts/validate-skin-package.sh) after building a ZIP.

For a macOS smoke test, unzip the archive into a temporary directory and invoke its `.command` installer with a temporary `HOME`; verify the resulting `.app`, CLI link, and doctor script. For Windows, parse or execute the PowerShell scripts in a Windows environment; at minimum verify the ZIP contains the `.cmd`, `.ps1`, shortcut creation, uninstall, skin assets, and launcher code.

## Completion Checklist

- Official app bundle and user data untouched.
- New Task visual is visible, high-impact, and does not intercept clicks.
- Conversation view hides home-only artwork.
- Reload reinstalls the skin automatically.
- A visible in-app switcher changes between every shipped static and dynamic skin with no app exit or WebView reload.
- The selected skin persists across reload; reduced-motion mode and narrow layouts remain usable.
- Text, composer, sidebar, and profile remain readable at desktop and narrow widths.
- macOS `.app` and Windows desktop shortcut are created by their respective installers.
- ZIP passes integrity and content validation.
- `doctor` checks required source assets and runtime syntax.
