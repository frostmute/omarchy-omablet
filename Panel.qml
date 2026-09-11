import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import qs.Commons
import qs.Ui

Item {
    id: root
    property bool opened: false
    readonly property string backend: decodeURIComponent(Qt.resolvedUrl("tablet-mode").toString()).replace(/^file:\/\//, "")

    function open(payloadJson) { opened = true }
    function close() { opened = false }
    function toggle() { opened = !opened }
    function run(action) {
        if (actionProcess.running)
            actionProcess.running = false
        if (action === "keyboard")
            actionProcess.command = ["omarchy-shell", "shell", "toggle", "io.github.frostmute.tablet-keyboard"]
        else if (action === "trackpad")
            actionProcess.command = ["omarchy-shell", "shell", "toggle", "io.github.frostmute.onscreen-trackpad"]
        else if (action === "system-lock")
            actionProcess.command = ["omarchy", "system", "lock"]
        else
            actionProcess.command = ["bash", backend, action]
        actionProcess.running = true
    }

    Process { id: actionProcess }
    Process {
        id: rotationWatcher
        command: ["bash", root.backend, "watch"]
        running: true
    }

    PanelWindow {
        id: panel
        visible: root.opened
        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"
        mask: Region { item: card }
        WlrLayershell.namespace: "io.github.frostmute.tablet-mode"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        exclusionMode: ExclusionMode.Ignore

        BorderSurface {
            id: card
            width: Style.space(620)
            height: Style.space(460)
            x: (panel.width - width) / 2
            y: panel.height - height - Style.spacing.lg
            radius: Style.cornerRadius
            color: Color.popups.background
            borderSpec: Border.hyprlandActiveSpec(Color.accent, 2)

            Column {
                anchors.fill: parent
                anchors.margins: Style.spacing.md
                spacing: Style.spacing.sm

                Text {
                    text: "Omablet"
                    color: Color.foreground
                    font.family: Style.font.family
                    font.pixelSize: Style.font.heading
                    font.bold: true
                }
                Text {
                    text: "Quick touch controls · manual rotation locks auto-rotate"
                    color: Color.muted
                    font.family: Style.font.family
                    font.pixelSize: Style.font.body
                }

                Grid {
                    width: parent.width
                    columns: 2
                    columnSpacing: Style.spacing.sm
                    rowSpacing: Style.spacing.sm
                    Repeater {
                        model: [
                            { label: "On-screen keyboard", action: "keyboard" },
                            { label: "On-screen trackpad", action: "trackpad" },
                            { label: "Auto-rotate", action: "auto" },
                            { label: "Lock rotation", action: "lock" },
                            { label: "Rotate left", action: "left" },
                            { label: "Rotate right", action: "right" },
                            { label: "Upright", action: "normal" },
                            { label: "Lock screen", action: "system-lock" }
                        ]
                        delegate: Rectangle {
                            required property var modelData
                            width: (parent.width - parent.columnSpacing) / 2
                            height: Style.space(60)
                            radius: Style.cornerRadius
                            color: tap.pressed ? Color.accent : Util.alpha(Color.foreground, Style.normalFillAlpha)
                            border.color: Util.alpha(Color.foreground, Style.pressedFillAlpha)
                            border.width: Style.normalBorderWidth
                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData.label
                                color: Color.foreground
                                font.family: Style.font.family
                                font.pixelSize: Style.font.body
                            }
                            MouseArea {
                                id: tap
                                anchors.fill: parent
                                onClicked: root.run(parent.modelData.action)
                            }
                        }
                    }
                }

                Item { width: 1; height: 1 }
                Rectangle {
                    width: parent.width
                    height: Style.space(52)
                    radius: Style.cornerRadius
                    color: Util.alpha(Color.foreground, Style.normalFillAlpha)
                    Text {
                        anchors.centerIn: parent
                        text: "Close"
                        color: Color.foreground
                        font.family: Style.font.family
                        font.pixelSize: Style.font.body
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.close()
                    }
                }
            }
        }
    }
}
