import QtQuick 2.0

import "global.js" as Global
import "board.js" as Board

Item {
    id: board

    Component.onCompleted: Board.create();

    //piece clicked
    signal mouseClicked(int pieceIndex)
    signal mouseEntered(int pieceIndex)

    signal scoreChanged(int count)
    signal doubleScore

    signal pieceDestroyed(int pieceIndex)


    property int nx: 10
    property int ny: 15


    property int cx: board.width / nx;
    property int cy: board.height / ny;


    onWidthChanged:     Board.resize();
    onHeightChanged:    Board.resize();
    onMouseClicked:     Board.onMouseClicked(pieceIndex);
    onMouseEntered:     Board.onMouseEntered(pieceIndex);
    onPieceDestroyed:   Board.destroyPiece(pieceIndex);

}
