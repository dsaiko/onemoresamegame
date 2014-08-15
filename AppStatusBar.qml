/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0


import "score.js" as Score
import "global.js" as Global

/**
  * Bottom status bar with menu button, level display and score counter
  *
  * code signoff date: 2014-08-15
  */
Item {
    property int level:         0
    property int totalScore:    0

    signal menuHide
    signal menuDisplay
    signal resetScore
    signal scoreAdded(int count, int numberOfColors)

    clip: true

    //background
    Image {
        anchors.fill:           parent
        source:                 Global.spritePath+"digit_B.png";
    }

    //digits
    Repeater {
        model: 65
        ScoreDigit {}
    }

    Row {
        spacing:                parent.height * 0.04
        x:                      spacing * 2
        y:                      spacing * 2
        width:                  parent.width - 2 * x
        height:                 parent.height - 2 * y

        PushButton {
            source:             Global.spritePath+"btnMenu.png"
            preferredHeight:    parent.height
            onClicked:          menuDisplay()
        }

        BetterImage {
            source:             Global.spritePath+"level.png"
            preferredHeight:    parent.height
        }

        SlidingImage {
            id:                 digit1
            source:             Global.spritePath+"level_0.png";
        }

        SlidingImage {
            id:                 digit2
            source:             Global.spritePath+"level_1.png"
        }
    }

    Component.onCompleted:      Score.init();
    onLevelChanged:             Score.displayLevel()
    onScoreAdded:               Score.addScore(count, numberOfColors)
    onResetScore:               Score.resetScore()
}
