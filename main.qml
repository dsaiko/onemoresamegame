import QtQuick 2.3
import QtQuick.Controls 1.0
import QtQuick.Window 2.0


ApplicationWindow {
    id: mainWindow

    visible: true

    height: Screen.height * 2 / 3
    width: Screen.width / 2

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

         onMenuDisplay: board.menuDisplay();
         onMenuHide: board.menuHide();

         level: board.level
    }

    Board {
         id: board
         width: parent.width
         height: parent.height - scoreBar.height         
         anchors.top: parent.top

         onSetMenuButtonType:scoreBar.menuButton.type = type
         onResetScore: scoreBar.resetScore()
         onNewGameStarted:  {
            if(mainWindow.visibility < 4) { //not maximized nor fullscreen
                if(board.nx < board.ny) {
                    mainWindow.height = Screen.height * 2 / 3
                    mainWindow.width = Screen.width / 2
                } else {
                    mainWindow.height = Screen.height / 2
                    mainWindow.width = Screen.width *2 / 3

                }
            }
         }
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
