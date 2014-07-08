import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Window 2.0


ApplicationWindow {
    visible: true

    height: Screen.height / 2
    width: Screen.height / 3

    minimumWidth: 200
    minimumHeight: 300
    title: qsTr("One More SameGame")

    Background {
           anchors.fill: parent
    }

    ScoreBar {
         id: scoreBar
         width: parent.width
         height: parent.height / 15
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
    }

}
