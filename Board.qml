import QtQuick 2.0

import "global.js" as Global
import "board.js" as Board

Item {
    id: board

    property int nx: 15
    property int ny: 20
    property int level: 1

    signal setMenuButtonType(int type)
    signal menuDisplay
    signal menuHide
    signal resetScore
    signal nextLevel

    Component.onCompleted: {
        Board.init();
        Board.create();
    }

    onLevelChanged: Board.create();

    EndOfGamePanel {
        id: endOfGamePanel
        visible: false

        onStartGameEasy: Board.startGameEasy()
        onStartGameMedium: Board.startGameMedium()
        onStartGameHard: Board.startGameHard()
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

    onMouseClicked:     Board.onMouseClicked(pieceIndex);
    onMouseEntered:     Board.onMouseEntered(pieceIndex);
    onMouseExited:      Board.onMouseExited(pieceIndex);
    onPieceDestroyed:   Board.destroyPiece(pieceIndex);
    onMenuDisplay:      Board.menuDisplay();
    onMenuHide:         Board.menuHide();

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
