#!/bin/bash
set -euo pipefail

ARCHIVE_PATH="${1:-}"
if [[ -z "$ARCHIVE_PATH" || ! -f "$ARCHIVE_PATH" ]]; then
  echo "用法：$0 <Codex-skin-package.zip>" >&2
  exit 2
fi

command -v unzip >/dev/null || { echo "缺少 unzip" >&2; exit 1; }
unzip -tqq "$ARCHIVE_PATH"

entries="$(unzip -Z1 "$ARCHIVE_PATH")"
[[ -n "$entries" ]] || { echo "ZIP 为空" >&2; exit 1; }
first_entry="$(printf '%s\n' "$entries" | /usr/bin/head -n 1)"
root="${first_entry%%/*}"
[[ -n "$root" && "$root" != "$first_entry" ]] || { echo "ZIP 必须包含一个顶层目录" >&2; exit 1; }

required=(
  "README.md"
  "skin/injector.mjs"
  "skin/theme.css"
  "skin/skin.js"
  "skin/platforms/windows/launch.ps1"
  "skin/platforms/windows/doctor.ps1"
  "skin/platforms/windows/uninstall.ps1"
)

for relative_path in "${required[@]}"; do
  expected="$root/$relative_path"
  if ! printf '%s\n' "$entries" | /usr/bin/grep -Fxq "$expected"; then
    echo "安装包缺失：$expected" >&2
    exit 1
  fi
done

# 安装器名称可以按皮肤命名，但 macOS / Windows 的安装与卸载入口必须齐全。
has_installer() {
  local action="$1"
  local extension="$2"
  printf '%s\n' "$entries" | /usr/bin/awk -v prefix="$root/$action-" -v suffix="$extension" '
    index($0, prefix) == 1 && substr($0, length($0) - length(suffix) + 1) == suffix { found = 1 }
    END { exit(found ? 0 : 1) }
  '
}

for spec in \
  "Install:.command" "Install:.cmd" "Install:.ps1" \
  "Uninstall:.command" "Uninstall:.cmd" "Uninstall:.ps1"; do
  action="${spec%%:*}"
  extension="${spec#*:}"
  if ! has_installer "$action" "$extension"; then
    echo "安装包缺少入口：$action-*$extension" >&2
    exit 1
  fi
done

# 这是动态皮肤 Skill：发布包必须能在 WebView 内保存当前选择并提供无障碍的低动效降级。
skin_js="$(unzip -p "$ARCHIVE_PATH" "$root/skin/skin.js")"
theme_css="$(unzip -p "$ARCHIVE_PATH" "$root/skin/theme.css")"
if ! printf '%s' "$skin_js" | /usr/bin/grep -q 'localStorage'; then
  echo "动态皮肤缺少本机选择持久化（localStorage）" >&2
  exit 1
fi
if ! printf '%s' "$theme_css" | /usr/bin/grep -q 'prefers-reduced-motion'; then
  echo "动态皮肤缺少 prefers-reduced-motion 降级" >&2
  exit 1
fi

if printf '%s\n' "$entries" | /usr/bin/grep -q '/runtime/\|zhizunbao-frontal-chroma\.png$'; then
  echo "安装包包含不应分发的运行日志或抠图源文件" >&2
  exit 1
fi

echo "安装包检查通过：$ARCHIVE_PATH"
