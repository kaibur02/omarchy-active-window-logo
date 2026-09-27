# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-09-27

Initial release.

### Added

- Bar widget showing the focused window's app icon, app name, and title as
  `App Name | Window Title`.
- App name and icon resolution through `DesktopEntries`, with a capitalized
  `appId` name fallback and a generic icon fallback.
- Title collapsing so the label shows only the app name when the window
  title already matches it.
- Long-title eliding, capped by a configurable `maxWidth` setting
  (default `260`).
- Left-click to focus the window; middle-click and right-click to close it.
- Hover tooltip showing the app name and window title.
- Automatic hiding when no window is focused and in vertical bars.
- Live theme reactivity through Omarchy's `Color` and `Style` singletons.

[1.0.0]: https://github.com/kaibur02/omarchy-active-window-logo/releases/tag/v1.0.0
