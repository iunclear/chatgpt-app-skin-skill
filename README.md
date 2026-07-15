# Codex Desktop Skinning

可复用的 Codex/ChatGPT Desktop 本地皮肤 Skill。它覆盖官方主题 token 分析、CDP 注入、背景与透明前景分层、页面状态切换、macOS/Windows 桌面入口、双平台安装包，以及真实 WebView 验证。

安装到本机 Skill 目录：

```bash
git clone https://github.com/iunclear/chatgpt-app-skin-skill.git \
  "${CODEX_HOME:-$HOME/.codex}/skills/codex-desktop-skinning"
```

调用：

```text
Use $codex-desktop-skinning to create and package a local Codex Desktop skin.
```

发布 ZIP 后使用 `scripts/validate-skin-package.sh <archive.zip>` 检查 macOS/Windows 安装入口、主题资源和不应分发的运行时文件。
