import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2


ApplicationWindow {
    visible: true

    signal scoreChanged(int count)

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

    onScoreChanged: {
        scoreBar.score += (count - 1) * (count - 1)
    }

    Component.onCompleted: {
        board.scoreChanged.connect(scoreChanged);
    }

}
