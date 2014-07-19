import QtQuick 2.0

import "global.js" as Global

Item {
    property alias source: image1.source

    property int position: 0

    onSourceChanged: animation.start();

    x: parent.width - (position + 1)*width
    y: 0
    height: parent.height
    width: height * image1.originalSize.width / image1.originalSize.height

    BetterImage {
        id: image1
        anchors.fill: parent;
        source: Global.digitsPath+"-.png"
        preserveAspectRatio: true
    }

    SequentialAnimation {
        id: animation

        PropertyAnimation {
            target: image1
            properties: "opacity"
            from: 1.0
            to: 0.2
            duration: 80
        }

        PropertyAnimation {
            target: image1
            properties: "opacity"
            from: 0.2
            to: 1
            duration: 80
        }
    }
}
