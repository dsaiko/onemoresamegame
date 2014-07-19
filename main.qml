import QtQuick 2.0
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
         x:0
         y:0
         opacity: 0.8

         onSetMenuButtonType:scoreBar.menuButton.type = type
         onResetScore: scoreBar.resetScore()
         onScoreChanged: scoreBar.scoreAdded(count, numberOfColors)
         onDoubleScore: scoreBar.doubleScore()
    }
}
