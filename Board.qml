import QtQuick 2.0

import "global.js" as Global
import "board.js" as Board

Item {
    id: board

    Component.onCompleted: Board.create();

    Rectangle {
        id: endOfGamePanel
        anchors.fill: parent
        visible: false

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            hoverEnabled: !PlatformDetails.isMobile;
        }

        color: "gray"
        opacity: 0.5
        z: 2
    }

    //piece clicked
    signal mouseClicked(int pieceIndex)
    signal mouseEntered(int pieceIndex)
    signal mouseExited(int pieceIndex)

    signal scoreChanged(int count)
    signal doubleScore

    signal pieceDestroyed(int pieceIndex)


    property int nx: 5
    property int ny: 10


    property int cx: board.width / nx;
    property int cy: board.height / ny;


    onWidthChanged:     Board.resize();
    onHeightChanged:    Board.resize();
    onMouseClicked:     Board.onMouseClicked(pieceIndex);
    onMouseEntered:     Board.onMouseEntered(pieceIndex);
    onMouseExited:      Board.onMouseExited(pieceIndex);
    onPieceDestroyed:   Board.destroyPiece(pieceIndex);

}
