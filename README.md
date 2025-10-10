# Cava Visualizer — Noctalia Bar Widget

A lightweight audio spectrum visualizer for the **Noctalia** shell bar, powered by **CAVA** and **Quickshell**.  
Renders smooth, configurable bars with minimal overhead.
! [Cava Visualizer](https://i.imgur.com/DfxRyMi.png)

---

## Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [File Layout](#file-layout)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Settings](#settings)
- [Performance Tips](#performance-tips)
- [Troubleshooting](#troubleshooting)
- [Uninstall](#uninstall)
- [License](#license)

---

## Features

- Uses **CAVA** in `raw → ascii` mode over stdout (no sockets or FIFOs).
- Efficient QML `Canvas` rendering (no per-frame object churn).
- Configurable: bars, width, spacing, radius, framerate, mono/stereo, smoothing.
- Auto-writes a minimal per-user CAVA config to Quickshell’s state path.

---

## Prerequisites

- **Noctalia / Quickshell** environment.
- **CAVA** installed and available on `PATH`:
  ```bash
  # Arch/CachyOS
  sudo pacman -S cava
  # Debian/Ubuntu
  sudo apt install cava

- PipeWire or PulseAudio (CAVA auto-detects; nothing to configure for most setups).

> **Note**: This widget expects unversioned QML imports for Quickshell (e.g., import Quickshell, not import Quickshell 1.0).

---

## File Layout

Place the files in your Noctalia repo (or in your QML overlay) as follows:
Services/
└─ BarWidgetRegistry.qml                # modified: registers the widget

Modules/
├─ Bar/
│  └─ Widgets/
│     └─ CavaVisualizer.qml            # new: the widget
└─ SettingsPanel/
   └─ Bar/
      └─ WidgetSettings/
         └─ CavaVisualizerSettings.qml # new: settings UI

If your project roots QML under `src/qml/`, prepend that prefix (e.g., `src/qml/Modules/...`).

---

## Installation

1. Copy files
- Add the two new QML files:
  - Modules/Bar/Widgets/CavaVisualizer.qml
  - Modules/SettingsPanel/Bar/WidgetSettings/CavaVisualizerSettings.qml
- Replace or edit Services/BarWidgetRegistry.qml to include the CavaVisualizer entries (already provided in this repo version).

2. Verify imports
- Ensure your CavaVisualizer.qml starts with:
  ```qml
  import QtQuick
  import Quickshell
  import Quickshell.Io
If your environment exposes different module names for I/O helpers, adjust accordingly.

3. Restart Noctalia
- systemd user service:
  ```bash
  systemctl --user restart noctalia-shell.service
  journalctl --user -u noctalia-shell.service -f
- Manual:
  ```bash
  pkill -TERM -f 'noctalia|quickshell'
  qs -c noctalia-shell

---

## Quick Start
Once the shell reloads:

1. Open your bar’s widget picker (or your config UI) and add “CavaVisualizer” to the bar.
2. Open the widget’s Settings to tune bars, width, spacing, framerate, etc.
3. Play audio—bars should animate immediately.

The widget writes a temporary CAVA config at runtime to Quickshell’s state directory (typically under `~/.local/share/quickshell/state/`).

---

## Settings

Accessible via your bar’s settings panel:
- Bars: default 48 (8–256).
- Bar Width / Spacing / Radius: visual appearance controls.
- Framerate: default 60 (24–120).
- ASCII Max: default 1000 (normalization range for CAVA ascii output).
- Noise Reduction: default 77 (CAVA smoothing).
- Mono: on/off (let CAVA mix channels or feed stereo).

> The widget recalculates and rewrites the CAVA config when relevant settings change.

---

## Performance Tips
- Keep bar width modest (2–4px) and spacing small to reduce overdraw.
- 60 fps is smooth; 30–48 can save CPU on low-power devices.
- If you don’t need the visualizer when the bar is hidden, the widget already ties CAVA’s process to visibility (`running: root.visible`).

---

## Troubleshooting

“Type CavaVisualizer unavailable” / “module Quickshell version 1.0 is not installed”
- Remove version suffixes: use import Quickshell (unversioned).
- Ensure quickshell’s QML import path is included in your runtime.

“Expected token } in BarWidgetRegistry.qml”
- You likely missed a comma or closing brace. Both big maps must end with }).
- Confirm these three registry edits exist and are syntactically correct:
1. In `widgets` map:
   - `"CavaVisualizer": cavaVisualizerComponent,`
2. In `widgetMetadata` map (complete block):
   ```qml
   "CavaVisualizer": {
      "allowUserSettings": true,
      "width": 300,
      "minHeight": 12,
      "maxHeight": 64,
      "bars": 48,
      "barWidth": 3,
      "barSpacing": 1,
      "framerate": 60,
      "mono": true
    },
3. Component factory in “Component definitions”:
   - `property Component cavaVisualizerComponent: Component { CavaVisualizer {} }`

“Type FileView/Process/SplitParser unavailable”
- Your Quickshell build may expose I/O helpers under different module names or plugins.
- Search the repo for FileView/Process usage and mirror those imports.
- As a fallback, you can write the CAVA config via a shell echo into a temp file and run cava against it.

**No animation / flat bars**
- Verify CAVA runs and detects audio: cava in a terminal should show output.
- Check your audio backend (PipeWire/Pulse). CAVA will auto-select by default.
- Increase ASCII Max if values look capped; tweak Noise Reduction.

**Crashes or hangs after edits**
- Validate QML formatting (optional):
  ```bash
  qs -c noctalia-shell
  # or
  journalctl --user -u noctalia-shell.service -f

---

## Uninstall
1. Remove the widget from the bar via your settings UI.
2. Delete these files:
   ```bash
   rm -rf Modules/Bar/Widgets/CavaVisualizer.qml
   rm -rf Modules/SettingsPanel/Bar/WidgetSettings/CavaVisualizerSettings.qml
3. Edit `Services/BarWidgetRegistry.qml` and remove:
   - the `"CavaVisualizer": cavaVisualizerComponent`, line from `widgets`
   - the `"CavaVisualizer": { ... }` block from `widgetMetadata`
   - the `property Component cavaVisualizerComponent: ...` factory
5. Restart Noctalia.

---

## License

MIT (or align with your project’s license). Update this section accordingly.

## Maintainers’ Notes

- The widget ties CAVA’s lifetime to visibility by default. For always-on behavior, set running: true.
- If you group widgets by category in your UI, feel free to add "category": "Audio" to the metadata and adapt your picker.
