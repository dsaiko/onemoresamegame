import QtQuick 2.3

import "global.js" as Global

Item {
    property alias source: image1.source

    onSourceChanged: animation.start();

    Image {
        id: image1
        anchors.fill: parent;
        source: Global.digitsPath+"-.png"
        mipmap: true
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
