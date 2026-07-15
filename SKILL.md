---
name: chatgpt-app-skin-skill
description: Design and implement polished skins, themes, layouts, and visual systems for ChatGPT Apps. Use when creating or restyling a ChatGPT App UI, choosing an art direction, defining design tokens, improving hierarchy and responsive behavior, or turning a functional app into a coherent product experience.
---

# ChatGPT App Skin

Create a complete visual direction for the app in front of you. Preserve useful product behavior and focus on the surfaces users operate: information hierarchy, component states, responsive layout, typography, color, and interaction feedback.

## Workflow

1. Inspect the existing stack, routes, reusable components, and product data. Identify the primary user task before styling anything.
2. Choose one visual direction that suits the product domain. Read `references/style-playbooks.md` when selecting or applying a direction.
3. Define a compact token set for canvas, surface, text, border, accent, success, warning, danger, spacing, radii, and shadows. Reuse the app's current token mechanism when one exists.
4. Establish hierarchy in this order: page shell, navigation, primary workspace, repeated content, then empty/loading/error states.
5. Implement the skin in the existing frontend conventions. Keep controls familiar, accessible, keyboard-usable, and large enough to operate on touch devices.
6. Verify desktop and narrow mobile layouts. Check long labels, overflow, contrast, focus visibility, disabled states, and loading or empty data.

## Visual Decisions

- Make the product and its current task visible in the first viewport. Do not replace an application screen with a marketing landing page.
- Use one coherent direction. A restrained palette with a distinct accent is stronger than many unrelated decorative treatments.
- Use semantic color roles rather than scattering raw values. Keep text, icons, borders, and interactive states distinguishable in both light and dark surfaces.
- Give dense operational interfaces predictable alignment, compact spacing, stable row heights, and clear scan paths. Use cards only for repeated items, dialogs, or genuinely bounded tools.
- Match type scale to the surface. Keep headings tight in panels and sidebars; reserve large display type for real page-level moments.
- Use familiar icons for compact tools. Pair unclear icons with tooltips and preserve text labels for irreversible or consequential commands.
- Prefer real product imagery only when it helps users understand an object, outcome, or state. Do not add decorative gradients, blurred atmosphere, or generic illustration to compensate for weak hierarchy.

## Implementation Rules

- Start from the current component library and CSS approach. Extend it before introducing a second styling system.
- Use CSS custom properties or the existing theme layer for tokens. Keep component overrides local and remove obsolete rules when changing direction.
- Design all interactive states: default, hover, focus-visible, active, disabled, selected, loading, empty, and error where applicable.
- Use responsive constraints such as grid tracks, `minmax()`, `clamp()` for layout dimensions only, and fixed control sizing when it prevents layout shift. Do not scale font size with viewport width.
- Respect reduced motion. Animation should clarify state changes, not decorate idle space.
- Keep changes scoped to the requested UI. Do not alter application behavior, data contracts, or unrelated routes unless the visual work requires it.

## Review Checklist

- The chosen visual direction supports the user's job and remains consistent across the page.
- The main action and current status are immediately clear.
- Text, controls, and repeated content fit at desktop and mobile widths without overlap or clipping.
- Color contrast, keyboard focus, and disabled/loading/error states are present.
- No placeholder copy, unfinished panels, or style conflicts remain.
