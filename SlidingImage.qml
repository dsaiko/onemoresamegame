/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0

Item {

    id: slidingImage

    property alias  source:         img0.source

    property real preferredHeight

    height: img0.height
    width: img0.width

    BetterImage {
        id: img0
        preferredHeight: parent.preferredHeight

    }

    BetterImage {
        id: backupImage;
        visible: false;
    }

    SequentialAnimation {
        id: animation

        ParallelAnimation {
            PropertyAnimation {
                target: img0
                property: "y"
                from: -slidingImage.height
                to: 0
                duration: 500
            }
            PropertyAnimation {
                target: backupImage
                property: "y"
                from: 0
                to: slidingImage.height
                duration: 500
            }
        }
        ScriptAction {
            script: {
                backupImage.source = img0.source
                backupImage.y = 0
                backupImage.width = img0.width
                backupImage.visible = true
            }
        }
    }

    onSourceChanged: {
        animation.start()
    }
}
