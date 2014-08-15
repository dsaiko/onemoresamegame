/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0
import "global.js" as Global

/**
  * Image with sliding effect on source change
  * there is a limitation that backupImage needs to have some image at startup with
  * the same dimensions as image later on ...
  *
  * code signoff date: 2014-08-15
  */
Item {
    property alias  source:         image.source

    height:     image.height
    width:      image.width

    BetterImage {
        id:                 image
        preferredHeight:    parent.parent.height

        onSourceChanged: {
            backupImage.visible = true
            animation.restart()
        }
    }

    BetterImage {
        source:         Global.spritePath+"level_9.png"
        id:             backupImage
        preferredHeight:parent.parent.height
        opacity:        0
    }

    // sliding animation effect which will swap the images at the end
    ParallelAnimation {
        id: animation

        PropertyAnimation {
            target:     image
            property:   "y"
            from:       -image.height
            to:         0
            duration:   750
        }
        PropertyAnimation {
            target:     backupImage
            property:   "y"
            from:       0
            to:         backupImage.height
            duration:   750
        }

        onStopped: {
            backupImage.visible = false
            backupImage.source = image.source
            backupImage.reComputeWidth
            backupImage.opacity = 1
        }
    }
}
