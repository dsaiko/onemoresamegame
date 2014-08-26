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
        source:                 Global.spritePath+"score.png";
    }

    //digits
    Repeater {
        model: 65
        ScoreDigit {}
    }

    Row {
        spacing:                parent.height * 0.1
        x:                      - parent.width * 0.598
        y:                      - parent.height / 2
        width:                  parent.width * 2
        height:                 parent.height * 2
        scale:                  0.40

        Item {
            height: parent.height
            width: height
            scale: 0.95

            PushButton {
                source:             Global.spritePath+"icon.png"
                preferredHeight:    parent.height
                onClicked:          menuDisplay()
            }
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
