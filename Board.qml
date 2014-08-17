/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "global.js" as Global
import "board.js" as Board

/**
  * Board component
  *
  * code signoff date: 2014-08-16
  */
Item {
    id: board

    property int boardGridWidth:        15
    property int boardGridHeight:       20
    property int level:                 1

    property string playerName
    property alias scoreModel:          menuPanel.scoreModel
    property alias roomNumber:          menuPanel.roomNumber
    property alias fallTimer:           fallTimer

    signal menuDisplay
    signal resetScore
    signal nextLevel

    signal mouseClicked(int index)
    signal mouseEntered(int index)
    signal mouseExited(int index)  

    signal scoreChanged(int count, int numberOfColors)

    Component.onCompleted:              Board.init()

    onLevelChanged:                     Board.create()

    MenuPanel {
        id: menuPanel
        visible: false

        onStartGame10x15:               Board.startGame(10,15)
        onStartGame20x15:               Board.startGame(20,15)
        onStartGame20x30:               Board.startGame(20,30)
        onStartGame40x30:               Board.startGame(40,30)
    }

    onMouseClicked:                     Board.onMouseClicked(index)
    onMouseEntered:                     Board.onMouseEntered(index)
    onMouseExited:                      Board.onMouseExited(index)
    onMenuDisplay:                      Board.menuDisplay()

    onNextLevel:                        Board.onNextLevel()


    Timer {
            id:                         fallTimer
            interval:                   300
            onTriggered:                Board.fallPieces()
    }

    ParallelAnimation {
        id: nextLevelAnimation

        readonly property int mainDuration: 2500

        PropertyAnimation {
            target:                     board
            property:                   "y"
            from:                       -board.height
            to:                         0

            easing {
                type:                   Easing.OutElastic
                amplitude:              1
                period:                 1.5
            }
            duration:                   nextLevelAnimation.mainDuration
        }


        PropertyAnimation {
            target:                     board
            property:                   "rotation"
            from:                       -360
            to:                         0

            easing {
                type:                   Easing.OutElastic
                amplitude:              1
                period:                 1.5
            }
            duration:                   nextLevelAnimation.mainDuration
        }


        PropertyAnimation {
            target:                     board
            property:                   "scale"
            from:                       0
            to:                         1

            easing {
                type:                   Easing.OutElastic
                amplitude:              1
                period:                 1.5
            }
            duration:                   nextLevelAnimation.mainDuration
        }
    }
}
