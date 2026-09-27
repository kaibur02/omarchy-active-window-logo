# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] — 2026-09-27

Initial release.

### Security

- The off-screen `Text` item used to measure the label's natural width now
  sets `textFormat: Text.PlainText`, matching the visible label.

  Window titles are attacker-controlled: any application can set its own
  title. That measurement item previously used Qt's default
  `Text.AutoText`, so a title containing an image tag was parsed as rich
  text and handed to Qt's rich-text layout while `implicitWidth` was being
  computed, which can trigger a fetch of a remote resource. A title such as
  `<img src="https://example.invalid/track.png">` would therefore cause the
  shell to issue an outbound request, disclosing the user's IP address and
  confirming that a particular application is running. With `PlainText` the
  title is treated as literal text and no markup is interpreted.

  Reported by a marketplace maintainer during submission review.

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
