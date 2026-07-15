# Platform Packaging

## Principles

- Keep skin sources under the user's profile directory, not inside the vendor application.
- Launch the vendor binary with a loopback-only remote debugging port and run the bundled Node injector as a child process.
- Stop the injector when the vendor application exits.
- Make every installed artifact user-local and removable without changing the official application or user data.

## macOS

Create `~/Applications/<skin name>.app` with an `Info.plist`, executable wrapper, and `.icns`. Use ad-hoc signing after copying the app bundle. The wrapper should call the installed skin's `launch.sh`.

Default discovery paths:

```text
ChatGPT app: /Applications/ChatGPT.app/Contents/MacOS/ChatGPT
Bundled Node: /Applications/ChatGPT.app/Contents/Resources/cua_node/bin/node
Skin root: ~/.codex/skins/<skin-name>
```

Require the official application to be fully quit before launch unless an explicit isolated-test override is set. Test the installer using an isolated `HOME`, then verify `plutil`, `codesign --verify --deep`, Node syntax checks, and the user-local command symlink.

## Windows

Use a PowerShell launcher with path overrides:

```text
CODEX_DAHUA_APP_BIN
CODEX_DAHUA_NODE_BIN
CODEX_DAHUA_PORT
```

Search common per-user ChatGPT install locations first, then use the adjacent `resources\\cua_node\\node.exe` or a system `node` fallback. Create `.lnk` files with `WScript.Shell` that target `powershell.exe -NoProfile -ExecutionPolicy Bypass -File <launcher>`; put one on Desktop and one under Start Menu Programs. Keep stdout and stderr log paths distinct because `Start-Process` rejects a shared redirect path.

## Release Layout

```text
Codex-<skin>-Skin-x.y.z/
  README.md
  Install-<skin>.command
  Install-<skin>.cmd
  Install-<skin>.ps1
  Uninstall-<skin>.command
  Uninstall-<skin>.cmd
  Uninstall-<skin>.ps1
  skin/
    theme.css
    skin.js
    injector.mjs
    assets/
    platforms/windows/
```

Exclude runtime logs, test profiles, release folders, and chroma-key source files. Archive the top-level directory and publish a SHA-256 sidecar.
