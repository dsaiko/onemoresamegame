/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
import QtQuick 2.0
import "global.js" as Global

/**
  * shining star animation for board piece
  *
  * code signoff date: 2014-08-15
  */
BetterImage {
    id:                             shiningStar
    width:                          parent.width / 2
    height:                         parent.height / 2
    opacity:                        0
    source:                         Global.spritePath+"shine.png"

    property alias shineAnimation:  shine
    Component.onCompleted:          shine.start()


    SequentialAnimation {
        id:                     shine

        property int delay:     Math.random() * 10000
        property int duration:  Math.random() * 400 + 200


        //first wait some time
        PropertyAnimation { duration: shine.delay }

        //start shine
        ParallelAnimation {
            SequentialAnimation {
                NumberAnimation {
                         target:        shiningStar
                         properties:    "opacity"
                         to:            0.8
                         duration:      shine.duration
                         easing.type:   Easing.InOutBounce
                }
                NumberAnimation {
                         target:        shiningStar
                         properties:    "opacity"
                         to:            0
                         duration:      shine.duration
                         easing.type:   Easing.InOutBounce
                }
            }
            NumberAnimation {
                     target:            shiningStar
                     properties:        "scale"
                     from:              0
                     to:                0.6
                     duration:          2 * shine.duration
                     easing.type:       Easing.InOutBounce
            }
        }

        //recompute delay time and shine duration
        onStopped: {
            shine.delay = Math.random() * 10000
            shine.duration = Math.random() * 400 + 200
            shine.start()
        }
    }
}

