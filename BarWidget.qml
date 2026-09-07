import QtQuick
import qs.Commons
import qs.Ui

BarWidget {
    id: root
    moduleName: "io.github.frostmute.tablet-mode"
    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight

    WidgetButton {
        id: button
        anchors.fill: parent
        bar: root.bar
        text: "󰍛"
        tooltipText: "Omablet"
        onPressed: function(buttonCode) {
            if (root.bar)
                root.bar.run("omarchy-shell shell toggle io.github.frostmute.tablet-mode")
        }
    }
}
