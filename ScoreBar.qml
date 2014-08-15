/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0


import "scorebar.js" as ScoreBar
import "global.js" as Global

Item {
    id: scoreBar
    property alias menuButton: menuButton

    signal menuHide
    signal menuDisplay
    signal resetScore

    property int level: 0    
    property int totalScore: 0
    property real margin: height * 0.08

    clip: true

    Image {
        id: scorebarBackground
        source: "/images/sprites/digit_B.png";
        anchors.fill: parent
    }


    Item {

        z: 1

        x: margin
        y: margin

        width:  parent.width - 2 * margin
        height: parent.height - 2 * margin

        PushButton {
            id: menuButton
            preferredHeight: parent.height

            source: Global.spritePath+"btnMenu.png"

           onClicked: scoreBar.menuDisplay()
        }

        ScoreBarLevel {
            id: levelPanel

            x: menuButton.width + margin
            y: 0;
            height: parent.height
            width: parent.width - x
        }
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
