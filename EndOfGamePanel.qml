import QtQuick 2.0

import "global.js" as Global
import "endofgamepanel.js" as Panel

Item {

    //0 - start of the game 1 - win -1 - loss
    property int type: 0
    property int savedShape: 0;
    property bool yAnimationEnabled: true

    signal getNewImage()

    id: endOfGamePanel
    width: parent.width
    height: parent.height
    x: 0


    signal startGameEasy
    signal startGameMedium
    signal startGameHard

    Rectangle {
        MouseArea {
            id: mouseArea
            anchors.fill: parent

            hoverEnabled: !PlatformDetails.isMobile;
        }

        anchors.fill: parent
        color: "#ffffff"
        opacity: 0.9
    }

    BetterImage {
        id: piece;
        preserveAspectRatio: true
    }

    BetterImage {
        id: face;
        smooth: true
        preserveAspectRatio: true
        opacity: 0.9
    }

    Item {
        id: levels;

        BetterImage {
            preserveAspectRatio: true

            source: Global.spritePath+"10x15.png";
            width: endOfGamePanel.parent.width / 3.5;
            height: endOfGamePanel.parent.height / 6
            x: (endOfGamePanel.parent.width - width) / 2
            y: endOfGamePanel.parent.height  * 3 / 8
            MouseArea {
                anchors.fill: parent
                hoverEnabled: !PlatformDetails.isMobile;
                cursorShape:  Qt.PointingHandCursor
                onClicked: startGameEasy();
            }

        }

        BetterImage {
            preserveAspectRatio: true
            source: Global.spritePath+"20x15.png";
            width: endOfGamePanel.parent.width / 3.5;
            height: endOfGamePanel.parent.height / 6
            x: (endOfGamePanel.parent.width - width) / 2
            y: endOfGamePanel.parent.height  * 4.5 / 8

            MouseArea {
                anchors.fill: parent
                hoverEnabled: !PlatformDetails.isMobile;
                cursorShape:  Qt.PointingHandCursor
                onClicked: startGameMedium();
            }
        }

        BetterImage {
            preserveAspectRatio: true
            source: Global.spritePath+"20x30.png";
            width: endOfGamePanel.parent.width / 3.5;
            height: endOfGamePanel.parent.height / 6
            x: (endOfGamePanel.parent.width - width) / 2
            y: endOfGamePanel.parent.height  * 6 / 8
            MouseArea {
                anchors.fill: parent
                hoverEnabled: !PlatformDetails.isMobile;
                cursorShape:  Qt.PointingHandCursor
                onClicked:    startGameHard();
            }
        }


    }

    Behavior on y {
        enabled: yAnimationEnabled

        SpringAnimation{
            spring: 4;
            damping: 0.3
            duration: 1000
        }
    }

    z: 2

    onWidthChanged:     Panel.onVisibleChanged()
    onHeightChanged:    Panel.onVisibleChanged()
    onVisibleChanged:   Panel.onVisibleChanged()
    onGetNewImage:      Panel.onVisibleChanged()
}