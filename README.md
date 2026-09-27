# Active Window Logo

A minimal bar widget for [Omarchy](https://omarchy.org) that shows the
currently focused window — its app icon and title — right in the bar.

- **App icon + name + window title** in a single, theme-matched label.
- **Click** to focus the window, **middle-click** or **right-click** to close it.
- Hides itself when there is no active window and in vertical bars.
- Resolves real app names and icons from `.desktop` entries, with a sane fallback.
- Fully theme-reactive: colors, fonts, and spacing come from Omarchy's
  `Color` / `Style` singletons, so theme switches restyle it live.

## Install

```sh
omarchy plugin add https://github.com/kaibur02/omarchy-active-window-logo.git --enable
```

## Usage

The widget appears automatically in the bar once installed (default section:
`left`). It shows the focused window as `App Name | Window Title`.

- **Left-click** the widget to bring the focused window to the front.
- **Middle-click** or **right-click** to close the focused window.
- Hover to see a tooltip with the full app name and title.

The label automatically shortens and elides when the window title is long,
so it never crowds out the rest of your bar.

## Configure

```sh
# Cap the label width (default 260px) to give the bar more or less room.
omarchy bar set io.github.kaibur02.omarchy-active-window-logo maxWidth 320

# Move it to a different bar section.
omarchy bar move io.github.kaibur02.omarchy-active-window-logo --after omarchy.menu
```

## Remove

```sh
omarchy plugin remove io.github.kaibur02.omarchy-active-window-logo
```

## Details

- Pure QML + manifest — no install hooks, no sudo, no daemons, no network
  calls, no background writes.
- Runs entirely inside `omarchy-shell` as an unsandboxed QML plugin with
  standard user permissions (the norm for Omarchy plugins).
- Reads only the active window's `appId`/`title` and resolves icons via
  `DesktopEntries` and `Quickshell.iconPath`. That is the entire data surface.
- The widget manages windows only in response to your own clicks; it never
  acts on its own.

## Compatibility

- Requires **Omarchy** (an `omarchy-shell` bar) — this is an Omarchy bar
  widget and does not apply to other setups.
- Uses the Quickshell/Wayland APIs and the Omarchy QML modules
  (`BarWidget`, `ToplevelManager`, `DesktopEntries`, `Style`), targeting
  plugin `schemaVersion: 1`.

## Files

| File            | What                          |
|-----------------|-------------------------------|
| `manifest.json` | Omarchy plugin manifest       |
| `Widget.qml`    | Bar widget (icon + title)     |
| `LICENSE`       | MIT license                   |

## License

MIT — see [LICENSE](LICENSE).
