/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0

import "scorebar.js" as ScoreBar
import "global.js" as Global

Item {
    id: button;

    property alias source: img.source
    property alias image: img
    property alias originalSize: img.originalSize
    property alias margin: img.margin

    property string text

    signal clicked
    property int type: 0
    x: 0
    y: 0
    z: 2

    BetterImage {
        id: img



        x:0
        y:0
        height: parent.height

        preserveAspectRatio: true

        MouseArea {
            anchors.fill: parent

            hoverEnabled: !PlatformDetails.isMobile
            cursorShape:  Qt.PointingHandCursor

            onPressed: {
                img.scale = 0.9
            }

            onReleased: {
                img.scale = 1
            }

            onClicked: {
                button.clicked()
            }
        }

        Behavior on y {
            PropertyAnimation {
                property: "y"
                duration: 100
            }
        }
        Behavior on x {
            PropertyAnimation {
                property: "x"
                duration: 100
            }
        }
        Behavior on scale {
            PropertyAnimation {
                property: "scale"
                duration: 100
            }
        }


        Text {
            text: button.text

            x: parent.height * 1.2
            anchors.verticalCenter: parent.verticalCenter

            font.pixelSize: Math.floor(button.height * 2 / 3.5)
            font.bold: true

            antialiasing: true
            smooth: true
            style: Text.Raised
            styleColor: "transparent"
            textFormat: Text.StyledText
        }
    }
}
