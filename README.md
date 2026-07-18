# Codex Desktop Skinning

可复用的 Codex/ChatGPT Desktop **动态皮肤** Skill。它覆盖官方主题 token 分析、CDP 注入、背景与透明前景分层、页面状态切换、macOS/Windows 桌面入口、双平台安装包，以及真实 WebView 验证。

从 1.1 起，示例安装包内置 Dynamic Skin Studio：右下角直接点「皮肤」，即可在不退出 ChatGPT 的情况下切换大话西游静态原版、月灯浮游、极光流体和星轨夜航。选择会保留到下次 WebView 加载；动效也有「全开 / 省电」开关并遵循系统的减少动态效果偏好。

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

## 示例安装包

`examples/dahua-xiyou/` 包含已校验的 `Codex-Dahua-Xiyou-Skin-1.1.0.zip` 及其 SHA-256 文件。解压后：macOS 双击 `Install-DahuaXiyou.command`，Windows 双击 `Install-DahuaXiyou.cmd`。安装后不用重启 ChatGPT 来切换皮肤。
