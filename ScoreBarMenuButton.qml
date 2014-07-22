import QtQuick 2.0

import "scorebar.js" as ScoreBar
import "global.js" as Global


Item {
    id: menuButton;
    signal menuHide
    signal menuDisplay

    z: 1
    property int type: 0
    x: 0
    y: 0
    height: scoreBar.height
    width: scoreBar.height

    BetterImage {
        id: btnMenu0
        source: Global.spritePath+"btnMenu0.png"
        x: 0
        y: 0
        height: scoreBar.height
        width: scoreBar.height
        margin: 0.1

        visible:  true
    }


    BetterImage {
        id: btnMenu1
        source: Global.spritePath+"btnMenu1.png"
        visible:  false

        x: 0;
        y: 0;
        height: scoreBar.height
        width: scoreBar.height
        margin: 0.1

        MouseArea {
            anchors.fill: parent

            hoverEnabled: !PlatformDetails.isMobile
            cursorShape:  Qt.PointingHandCursor

            onClicked:  menuHide()
        }
    }

    BetterImage {
        id: btnMenu2;
        source: Global.spritePath+"btnMenu2.png"
        x: 0
        y: 0
        height: scoreBar.height
        width: scoreBar.height
        margin: 0.1

        visible:  false

        MouseArea {
            anchors.fill: parent

            hoverEnabled: !PlatformDetails.isMobile
            cursorShape:  Qt.PointingHandCursor

            onClicked:  menuDisplay()
        }
    }

    onTypeChanged: {

        btnMenu0.visible = false
        btnMenu1.visible = false
        btnMenu2.visible = false

        if(type == 1) {
            btnMenu1.visible = true
        } else
        if(type == 2) {
            btnMenu2.visible = true
        } else {
            btnMenu0.visible = true
        }
    }

}
