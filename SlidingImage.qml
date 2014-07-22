import QtQuick 2.0

Item {

    id: slidingImage

    property alias  source:         img0.source

    property real   margin:         0
    property real   marginLeft:     0
    property real   marginRight:    0
    property real   marginTop:      0
    property real   marginBottom:   0

    width: img0.width

    BetterImage {
        id: img0
        height: parent.height

        margin: parent.margin
        marginLeft: parent.marginLeft
        marginRight: parent.marginRight
        marginTop: parent.marginTop
        marginBottom: parent.marginBottom
    }

    BetterImage {
        id: backupImage;
        height: parent.height
        visible: false;

        margin: parent.margin
        marginLeft: parent.marginLeft
        marginRight: parent.marginRight
        marginTop: parent.marginTop
        marginBottom: parent.marginBottom
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
                backupImage.visible = true
            }
        }
    }

    onSourceChanged: {
        animation.start()
    }
}
