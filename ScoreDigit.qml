/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
import QtQuick 2.0
import "global.js" as Global

/**
  * Score displaying digit
  *
  * code signoff date: 2014-08-15
  */
BetterImage {

    id:                 digit
    objectName:         "ScoreDigit"
    source:             Global.spritePath+"score.png"
    preferredHeight:    parent.height
    onSourceChanged:    animation.start()

    x: parent.width - (index + 1) * width

    SequentialAnimation {
        id: animation

        PropertyAnimation {
            target: digit
            properties: "opacity"
            to: 0.2
            duration: 80
        }

        PropertyAnimation {
            target: digit
            properties: "opacity"
            to: 1
            duration: 80
        }
    }
}
