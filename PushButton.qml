/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0

import "scorebar.js" as ScoreBar
import "global.js" as Global

BetterImage {
    property string text

    signal clicked

    x: 0
    y: 0
    z: 2

    MouseArea {
        anchors.fill: parent

        hoverEnabled: !PlatformDetails.isMobile
        cursorShape:  Qt.PointingHandCursor

        onPressed: parent.scale = 0.9
        onReleased: parent.scale = 1
        onClicked: parent.clicked()
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
        text: parent.text

        x: parent.height * 1.2
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: Math.floor(parent.height * 2 / 3.5)
        font.bold: true

        antialiasing: true
        smooth: true
        style: Text.Raised
        styleColor: "transparent"
        textFormat: Text.StyledText
    }
}
