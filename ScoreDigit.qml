/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0

import "global.js" as Global

BetterImage {

    id: scoreDigit

    property int position: 0

    onSourceChanged: animation.start()

    x: parent.width - (position + 1)*width
    y: 0

    source: Global.digitsPath+"-.png"
    preferredHeight: parent.height

    SequentialAnimation {
        id: animation

        PropertyAnimation {
            target: scoreDigit
            properties: "opacity"
            from: 1.0
            to: 0.2
            duration: 80
        }

        PropertyAnimation {
            target: scoreDigit
            properties: "opacity"
            from: 0.2
            to: 1
            duration: 80
        }
    }
}
