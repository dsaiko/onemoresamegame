import QtQuick 2.3
import QtQuick.Controls 1.0
import QtQuick.Window 2.0


ApplicationWindow {
    visible: true

    height: Screen.height / 2
    width: Screen.width / 3

    minimumWidth: 200
    minimumHeight: 300
    title: qsTr("One More SameGame")
    signal resized

    Background {
           anchors.fill: parent
    }

    ScoreBar {
         id: scoreBar
         width: parent.width
         height: parent.height / 20
         anchors.bottom: parent.bottom
    }

    Board {
         id: board
         width: parent.width
         height: parent.height - scoreBar.height
         anchors.top: parent.top
    }

    Component.onCompleted: {
        board.scoreChanged.connect(scoreBar.scoreAdded);
        board.doubleScore.connect(scoreBar.doubleScore);
        board.resized.connect(resized);
        resize();
    }

    onWidthChanged: resize();
    onHeightChanged: resize();
    onResized: resize();

    function resize() {
        if(width > 0 && height > 0 && board.width > 0 && board.height > 0 && board.nx > 0 && board.ny > 0) {
            var cx = (board.width / board.nx)
            var cy = (board.height / board.ny)

            var d = Math.min(cx, cy);

            width  = d * board.nx;
        }
    }
}
