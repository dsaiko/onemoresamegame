/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
import QtQuick 2.0

import "global.js" as Global
import "menupanel.js" as Panel

//code signoff date: 2014-08-21
Rectangle {
    id:                                         menuPanel

    width:                                      parent.width
    height:                                     parent.height
    x:                                          0
    y:                                          -parent.height
    visible:                                    false
    color:                                      Qt.rgba(0.2, 0.2, 0.2, 0.8)
    z:                                          2


    //0 - start of the game 1 - win -1 - loss
    property int type:                          0
    property bool yAnimationEnabled:            true
    property bool requestHiding:                false

    readonly property real isLandscapeLayout:   parent.width > parent.height
    readonly property real titleHeight:         isLandscapeLayout ? height / 20 : height / 25
    readonly property int titleFontSize:        Math.floor(titleHeight * 0.4)
    readonly property int titleRadius:          titleHeight * 0.2
    readonly property int titleSpacing:         titleHeight / 15

    property alias scoreModel:                  panelScore.scoreModel
    property alias loadingAnimation:            panelScore.loadingAnimation
    property alias playerName:                  menuPanelInputs.playerName
    property alias roomNumber:                  menuPanelInputs.roomNumber

    signal startGame1
    signal startGame2
    signal startGame3
    signal startGame4
    signal getNewImage

    onGetNewImage:                              panelScore.getNewImage()


    readonly property real lanscapeWidth:       Math.min(width, height * 1.5) * 0.95

    MouseArea {
        id:                                     mouseArea
        anchors.fill:                           parent
        hoverEnabled:                           !PlatformDetails.isMobile; //disabling hover on underlaying pieces
    }

    MenuPanelButtons {
        id:                                     panelButtons
        anchors.horizontalCenter:               parent.horizontalCenter

        width:                                  parent.width
        height:                                 parent.height
    }

    MenuPanelInputs {
        id:                                     menuPanelInputs

        x:                                      isLandscapeLayout ? panelGames.x + panelGames.width + 5 * titleSpacing : panelGames.x
        y:                                      isLandscapeLayout ? titleHeight : titleHeight /2
        width:                                  isLandscapeLayout ? lanscapeWidth - panelGames.width - 5 * titleSpacing : parent.width * 0.9
        height:                                 titleHeight * 2
    }

    MenuPanelGames {
        id: panelGames

        x:                                      isLandscapeLayout ? (parent.width - lanscapeWidth) / 2 : (parent.width - width) / 2
        y:                                      isLandscapeLayout ? menuPanelInputs.y : menuPanelInputs.y + menuPanelInputs.height + titleSpacing
        width:                                  isLandscapeLayout ? lanscapeWidth / 3: parent.width * 0.9
        height:                                 isLandscapeLayout ? panelButtons.topY - titleHeight - y: titleHeight * 3.5

        onStartGame1:                           menuPanel.startGame1()
        onStartGame2:                           menuPanel.startGame2()
        onStartGame3:                           menuPanel.startGame3()
        onStartGame4:                           menuPanel.startGame4()
    }

    MenuPanelScore {
        id:                                     panelScore

        x:                                      menuPanelInputs.x
        y:                                      isLandscapeLayout ? menuPanelInputs.y + menuPanelInputs.height + titleSpacing : panelGames.y + panelGames.height + titleSpacing
        width:                                  menuPanelInputs.width
        height:                                 isLandscapeLayout ? panelGames.y + panelGames.height - y : panelButtons.topY - y - titleHeight /2
    }

    Behavior on y {
        enabled:                                yAnimationEnabled

        PropertyAnimation {
            property:                           "y"
            duration:                           750
            easing {
                type:                           Easing.InOutBack
                amplitude:                      1
                period:                         .5
            }
            onRunningChanged: {
                if(running == false && menuPanel.requestHiding) {
                    menuPanel.visible = false
                }
            }
        }
    }
}
