# ChatGPT App Skin Skill

A reusable Codex skill for generating polished skins, themes, layouts, and visual systems for ChatGPT Apps.

It guides a complete UI restyle: choosing a direction that fits the product, defining semantic tokens, improving hierarchy and responsive behavior, and validating interaction states without changing the app's intended behavior.

## Included

- `SKILL.md`: concise, executable workflow for visual design and implementation.
- `references/style-playbooks.md`: four product-oriented art directions for focused, operational, editorial, and collaborative apps.
- `agents/openai.yaml`: display metadata and a ready-to-use prompt for supported Skill environments.

## Install

```bash
git clone https://github.com/iunclear/chatgpt-app-skin-skill.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/chatgpt-app-skin-skill"
```

Then invoke it in a task:

```text
Use $chatgpt-app-skin-skill to design and implement a polished visual direction for this ChatGPT App.
```

## License

Apache-2.0. See [LICENSE](LICENSE).
