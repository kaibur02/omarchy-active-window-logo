import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import qs.Ui

// Active Window Logo
// Shows the focused window's app icon and title in the Omarchy bar.
// Left-click activates the window; middle/right-click closes it.
BarWidget {
  id: root
  moduleName: "io.github.kaibur02.omarchy-active-window-logo"

  // The currently focused Wayland toplevel (window).
  readonly property var toplevel: ToplevelManager.activeToplevel
  readonly property string appId: toplevel ? String(toplevel.appId || "") : ""
  readonly property string title: toplevel ? String(toplevel.title || "") : ""

  // Max pixel width for the label before it elides. Configurable via
  // `omarchy bar set io.github.kaibur02.omarchy-active-window-logo maxWidth <n>`.
  readonly property int maxLabelWidth: Number(setting("maxWidth", 260))
  readonly property int iconSize: Style.space(14)

  // Human-readable app name from the .desktop entry, falling back to the
  // capitalized appId when no matching entry exists.
  readonly property string appName: {
    if (appId === "") return ""
    var entry = DesktopEntries.byId(appId)
    if (entry) return String(entry.name || "")
    return appId.charAt(0).toUpperCase() + appId.slice(1)
  }

  // Resolve the app's icon, with a generic fallback so the widget never
  // renders a broken/empty image.
  readonly property string iconSource: {
    if (appId === "") return ""
    var entry = DesktopEntries.byId(appId)
    var iconName = entry ? String(entry.icon || "") : appId
    var result = Quickshell.iconPath(iconName, "application-x-executable")
    if (result && result.length > 0) return result
    return Quickshell.iconPath("application-x-executable", "")
  }

  // "App Name | Window Title", collapsing to just the app name when the
  // title is empty or already matches the app name.
  readonly property string displayText: {
    var name = appName
    if (name === "") return title
    var t = title.trim()
    if (t === "" || t.toLowerCase() === name.toLowerCase()) return name
    return name + " | " + t
  }

  visible: (title !== "" || appName !== "") && !vertical
  implicitWidth: visible ? Style.space(4) + (appIcon.status === Image.Ready ? iconSize + Style.space(6) : 0) + Math.min(maxLabelWidth, measureText.implicitWidth) + Style.space(8) : 0
  implicitHeight: barSize

  // Off-screen copy of the label used only to measure its natural width.
  // Must stay PlainText: the window title is untrusted, and Text.AutoText
  // would let a title such as `<img src="https://...">` reach Qt's rich-text
  // layout while implicitWidth is computed, fetching a remote resource.
  Text {
    id: measureText
    visible: false
    textFormat: Text.PlainText
    text: root.displayText
    font.family: root.bar ? root.bar.fontFamily : Style.font.family
    font.pixelSize: Style.font.body
  }

  Behavior on implicitWidth {
    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
  }

  Item {
    id: contentBox
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: Style.space(4)
    width: parent.width - Style.space(8)
    height: parent.height
    clip: true

    Image {
      id: appIcon
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      width: root.iconSize
      height: root.iconSize
      fillMode: Image.PreserveAspectFit
      sourceSize.width: width * Screen.devicePixelRatio
      sourceSize.height: height * Screen.devicePixelRatio
      source: root.iconSource
      opacity: 0.85
    }

    Text {
      textFormat: Text.PlainText
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: appIcon.status === Image.Ready ? appIcon.right : parent.left
      anchors.leftMargin: appIcon.status === Image.Ready ? Style.space(6) : 0
      anchors.right: parent.right
      text: root.displayText
      color: root.bar ? root.bar.barForeground : Color.foreground
      font.family: root.bar ? root.bar.fontFamily : Style.font.family
      font.pixelSize: Style.font.body
      elide: Text.ElideRight
      opacity: 0.85
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    cursorShape: Qt.PointingHandCursor
    onClicked: function(mouse) {
      if (!root.toplevel) return
      if (mouse.button === Qt.MiddleButton || mouse.button === Qt.RightButton)
        root.toplevel.close()
      else
        root.toplevel.activate()
    }
    onEntered: if (root.bar) root.bar.showTooltip(root, root.appName + (root.title ? " | " + root.title : ""))
    onExited: if (root.bar) root.bar.hideTooltip(root)
  }
}