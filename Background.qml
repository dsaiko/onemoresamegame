/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
import QtQuick 2.0
import "global.js" as Global

/**
  * Main application background created from set of squares with different size, color and opacity.
  *
  * code signoff date: 2014-08-15
  */
Item {
    anchors.fill: parent

    Repeater {
        model: 450

        Rectangle {

            readonly property var rnd:              Global.generateRandomArray(8)

            readonly property real  preferredWidth: rnd[0] * parent.width / 10 + parent.width / 30
            readonly property real  preferredHeight:rnd[1] * parent.height / 10 + parent.height / 30

            x:                                      rnd[2] * parent.width - width / 2
            y:                                      rnd[3] * parent.height - height / 2

            width:                                  Math.min(preferredWidth, preferredHeight)
            height:                                 width

            color:                                  Qt.rgba(rnd[4] * 0.2, rnd[5] * 0.2, rnd[6] * 0.2, rnd[7] * 0.2)
        }
    }
}
