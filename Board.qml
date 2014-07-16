import QtQuick 2.3

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
    signal newGameStarted;

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
    signal resized

    signal scoreChanged(int count, int numberOfColors)
    signal doubleScore

    signal pieceDestroyed(int pieceIndex)

    property int cx: board.width / nx;
    property int cy: board.height / ny;


    onWidthChanged:     Board.resize();
    onHeightChanged:    Board.resize();
    onMouseClicked:     Board.onMouseClicked(pieceIndex);
    onMouseEntered:     Board.onMouseEntered(pieceIndex);
    onMouseExited:      Board.onMouseExited(pieceIndex);
    onPieceDestroyed:   Board.destroyPiece(pieceIndex);
    onMenuDisplay:      Board.menuDisplay();
    onMenuHide:         Board.menuHide();

}
