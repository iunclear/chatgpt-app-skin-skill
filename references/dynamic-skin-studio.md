# Dynamic Skin Studio

## Product bar

This is not a gallery of static wallpapers. A released skin should have three visible advantages:

1. **Motion language** — each dynamic skin changes spatial behavior, not merely colors: drifting imagery/light, fluid aurora, and orbital geometry are distinct.
2. **In-app control** — a fixed, non-modal `皮肤` trigger opens a compact panel above the native WebView. Switching writes a root data attribute in the current document; it never relaunches the desktop app.
3. **Respectful performance** — decorative motion has a low-motion switch, follows `prefers-reduced-motion`, uses local assets only, and stays behind controls with `pointer-events: none`.

## Contract

Use a registry such as:

```js
const THEMES = [
  { id: "xiyou-static", label: "大话西游", kind: "static" },
  { id: "xiyou-lantern", label: "月灯浮游", kind: "dynamic" },
  { id: "aurora-flow", label: "极光流体", kind: "dynamic" },
  { id: "orbit-night", label: "星轨夜航", kind: "dynamic" },
];
```

- Apply with `document.documentElement.dataset.skinTheme = id` (or a skin-scoped equivalent).
- Persist with a versioned localStorage key. Validate the stored value against the registry before applying it.
- The button must expose `aria-expanded`, each option must expose `aria-pressed`, and the result must be announced through an `aria-live` status.
- Mount only once and remove the panel, attributes, observers, and presentation layers in `dispose()` so injector hot reload remains clean.

## Motion budget

- Prefer CSS gradients, pseudo-elements, `transform`, and `opacity`; avoid JS animation loops.
- Do not use a remote video, GIF, or an unbounded Canvas/WebGL loop for a backdrop.
- Put the scene at z-index 0, native content above it, and scene layers at `pointer-events: none`.
- Pause decorative CSS animations in explicit low-motion mode and `@media (prefers-reduced-motion: reduce)`.
- Test 1440px, 900px, and 720px widths. The switcher should remain reachable and may collapse its options to one column on narrow screens.

## Acceptance test

1. Open the New Task page and open `皮肤`.
2. Select each registry item; the visual changes immediately, the app does not reload, and a live status confirms it.
3. Reload the WebView: the previously selected item returns.
4. Turn on low motion: decorative animations stop while all ChatGPT/Codex controls still work.
5. Navigate to a conversation and back; no duplicate switcher or scene remains.
