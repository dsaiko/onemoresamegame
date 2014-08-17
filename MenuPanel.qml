/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0

import "global.js" as Global
import "menupanel.js" as Panel

//code signoff date: 2014-08-17
Rectangle {
    id:                                 menuPanel

    width:                              parent.width
    height:                             parent.height
    x:                                  0
    y:                                  -parent.height
    visible:                            false
    color:                              Qt.rgba(0.2, 0.2, 0.2, 0.8)
    z:                                  2


    //0 - start of the game 1 - win -1 - loss
    property int type:                  0
    property bool yAnimationEnabled:    true
    property bool requestHiding:        false

    property alias headerHeight:        panelScore.headerHeight
    property alias scoreModel:          panelScore.scoreModel
    property alias playerName:          panelGames.playerName
    property alias roomNumber:          panelGames.roomNumber

    signal startGame10x15
    signal startGame20x15
    signal startGame20x30
    signal startGame40x30
    signal getNewImage

    onGetNewImage:                      panelGames.getNewImage()


    MouseArea {
        id:                             mouseArea
        anchors.fill:                   parent
        hoverEnabled:                   !PlatformDetails.isMobile; //disabling hover on underlaying pieces
    }

    MenuPanelButtons {
        id:                             panelButtons
        anchors.horizontalCenter:       parent.horizontalCenter

        width:                          parent.width
        height:                         parent.height
    }

    MenuPanelGames {
        id: panelGames

        type:                           menuPanel.type

        onStartGame10x15:               menuPanel.startGame10x15()
        onStartGame20x15:               menuPanel.startGame20x15()
        onStartGame20x30:               menuPanel.startGame20x30()
        onStartGame40x30:               menuPanel.startGame40x30()
    }

    MenuPanelScore {
        id:                             panelScore
    }

    Behavior on y {
        enabled:                        yAnimationEnabled

        PropertyAnimation {
            property:                   "y"
            duration:                   750
            easing {
                type:                   Easing.InOutBack
                amplitude:              1
                period:                 .5
            }
            onRunningChanged: {
                if(running == false && menuPanel.requestHiding) {
                    menuPanel.visible = false
                }
            }
        }
    }


}
