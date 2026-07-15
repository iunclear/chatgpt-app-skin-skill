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
  "Install-DahuaXiyou.command"
  "Install-DahuaXiyou.cmd"
  "Install-DahuaXiyou.ps1"
  "Uninstall-DahuaXiyou.command"
  "Uninstall-DahuaXiyou.cmd"
  "Uninstall-DahuaXiyou.ps1"
  "skin/injector.mjs"
  "skin/theme.css"
  "skin/skin.js"
  "skin/assets/app-icon.ico"
  "skin/assets/zhizunbao-frontal.png"
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

if printf '%s\n' "$entries" | /usr/bin/grep -q '/runtime/\|zhizunbao-frontal-chroma\.png$'; then
  echo "安装包包含不应分发的运行日志或抠图源文件" >&2
  exit 1
fi

echo "安装包检查通过：$ARCHIVE_PATH"
