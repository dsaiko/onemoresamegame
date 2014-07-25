import QtQuick 2.0


import "scorebar.js" as ScoreBar
import "global.js" as Global

Item {
    id: scoreBar;
    property alias menuButton: menuButton

    signal menuHide
    signal menuDisplay
    signal resetScore

    property int level: 0    

    clip: true

    Image {
        id: scorebarBackground
        source: "/images/sprites/digit_B.png";
        anchors.fill: parent
    }


    ScoreBarMenuButton {
        id: menuButton

        onMenuDisplay: scoreBar.menuDisplay()
    }

    ScoreBarLevel {
        id: levelPanel
        z: 1

        x: scoreBar.height;
        y: 0;

        height: scoreBar.height;
    }


    onLevelChanged: {
        levelPanel.level = level
    }

    signal scoreAdded(int count, int numberOfColors)
    signal doubleScore

    Component.onCompleted:  ScoreBar.create();

    onDoubleScore:          ScoreBar.doubleScore();
    onScoreAdded:           ScoreBar.addScore(count, numberOfColors);
    onResetScore:           ScoreBar.resetScore()
}
