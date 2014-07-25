import QtQuick 2.0

import "global.js" as Global
import "menupanel.js" as Panel

Rectangle {

    //0 - start of the game 1 - win -1 - loss
    property int type: 0
    property bool yAnimationEnabled: true
    property bool requestHiding: false

    signal getNewImage()

    id: menuPanel
    width: parent.width
    height: parent.height
    x: 0
    y: -parent.height
    visible: false
    color: "#e1e1e1"

    signal startGameEasy
    signal startGameMedium
    signal startGameHard


    MenuPanelBackground {
        anchors.fill: parent
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent

        //disabling hover on underlaying pieces
        hoverEnabled: !PlatformDetails.isMobile;
    }

    MenuPanelButtons {
        id: panelButtons
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width
        height: parent.height
    }

    MenuPanelGames {
        id: panelGames
    }


//    BetterImage {
//        id: piece;
//        preserveAspectRatio: true
//    }

//    BetterImage {
//        id: face;
//        smooth: true
//        preserveAspectRatio: true
//        opacity: 1
//    }

//    Item {
//        id: levels;

//        BetterImage {
//            preserveAspectRatio: true

//            source: Global.spritePath+"10x15.png"
//            width: menuPanel.parent.width / 3.5
//            height: menuPanel.parent.height / 6
//            x: (menuPanel.parent.width - width) / 2
//            y: menuPanel.parent.height  * 3 / 8
//            MouseArea {
//                anchors.fill: parent
//                hoverEnabled: !PlatformDetails.isMobile;
//                cursorShape:  Qt.PointingHandCursor
//                onClicked: startGameEasy();
//            }

//        }

//        BetterImage {
//            preserveAspectRatio: true
//            source: Global.spritePath+"20x15.png"
//            width: menuPanel.parent.width / 3.5
//            height: menuPanel.parent.height / 6
//            x: (menuPanel.parent.width - width) / 2
//            y: menuPanel.parent.height  * 4.5 / 8

//            MouseArea {
//                anchors.fill: parent
//                hoverEnabled: !PlatformDetails.isMobile;
//                cursorShape:  Qt.PointingHandCursor
//                onClicked: startGameMedium();
//            }
//        }

//        BetterImage {
//            preserveAspectRatio: true
//            source: Global.spritePath+"20x30.png"
//            width: menuPanel.parent.width / 3.5
//            height: menuPanel.parent.height / 6
//            x: (menuPanel.parent.width - width) / 2
//            y: menuPanel.parent.height  * 6 / 8
//            MouseArea {
//                anchors.fill: parent
//                hoverEnabled: !PlatformDetails.isMobile
//                cursorShape:  Qt.PointingHandCursor
//                onClicked:    startGameHard()
//            }
//        }
//    }

    Behavior on y {

        enabled: yAnimationEnabled

        PropertyAnimation {
            property: "y"

            duration: 750

            easing {
                type: Easing.InOutBack
                amplitude: 1
                period: .5
            }

            onRunningChanged: {
                if(running == false && menuPanel.requestHiding) {
                    menuPanel.visible = false
                }
            }
        }
    }

    z: 2

    onGetNewImage:      Panel.onVisibleChanged()
}
