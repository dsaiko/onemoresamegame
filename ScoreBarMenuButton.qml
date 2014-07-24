import QtQuick 2.0

import "scorebar.js" as ScoreBar
import "global.js" as Global


Item {
    id: menuButton;
    signal menuDisplay

    z: 1
    property int type: 0
    x: 0
    y: x
    height: scoreBar.height
    width: scoreBar.height

    BetterImage {
        id: btnMenu
        source: Global.spritePath+"btnMenu.png"
        x: 0
        y: x
        height: scoreBar.height
        width: scoreBar.height

        margin: 0.1
        visible:  true

        MouseArea {
            anchors.fill: parent

            hoverEnabled: !PlatformDetails.isMobile
            cursorShape:  Qt.PointingHandCursor

            onPressed: {
                btnMenu.scale = 0.9
                btnMenu.x = btnMenu.width / 15
            }

            onReleased: {
                btnMenu.scale = 1
                btnMenu.x = 0
            }

            onClicked: {
                menuDisplay()
            }
        }
    }



}
