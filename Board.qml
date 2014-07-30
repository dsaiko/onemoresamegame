import QtQuick 2.0

import "global.js" as Global
import "board.js" as Board

Item {
    id: board

    property int nx:    15
    property int ny:    20
    property int level: 1

    signal menuDisplay
    signal resetScore
    signal nextLevel

    Component.onCompleted: {
        Board.init();
        Board.create();
    }

    onLevelChanged: Board.create()

    MenuPanel {
        id: menuPanel
        visible: false
        opacity: 0.95


        onStartGame10x15: Board.startGame(10,15)
        onStartGame20x15: Board.startGame(20,15)
        onStartGame20x30: Board.startGame(20,30)
        onStartGame40x30: Board.startGame(40,30)
    }

    //piece clicked
    signal mouseClicked(int pieceIndex)
    signal mouseEntered(int pieceIndex)
    signal mouseExited(int pieceIndex)

    signal scoreChanged(int count, int numberOfColors)
    signal doubleScore

    signal pieceDestroyed(int pieceIndex)

    property int cx: board.width / nx;
    property int cy: board.height / ny;

    onMouseClicked:     Board.onMouseClicked(pieceIndex)
    onMouseEntered:     Board.onMouseEntered(pieceIndex)
    onMouseExited:      Board.onMouseExited(pieceIndex)
    onPieceDestroyed:   Board.destroyPiece(pieceIndex)
    onMenuDisplay:      Board.menuDisplay()   

    onNextLevel: Board.onNextLevel()

    ParallelAnimation {
        id: nextLevelAnimation

        property int mainDuration: 2000

        PropertyAnimation {
            target: board
            property: "y"
            from: - board.height
            to: 0

            easing {
                type: Easing.OutElastic
                amplitude: 1
                period: 1.5
            }
            duration: nextLevelAnimation.mainDuration
        }


        PropertyAnimation {
            target: board
            property: "rotation"
            from: -360
            to: 0

            easing {
                type: Easing.OutElastic
                amplitude: 1
                period: 1.5
            }
            duration: nextLevelAnimation.mainDuration
        }



        PropertyAnimation {
            target: board
            property: "scale"
            from: 0
            to: 1

            easing {
                type: Easing.OutElastic
                amplitude: 1
                period: 1.5
            }
            duration: nextLevelAnimation.mainDuration
        }

    }
}
