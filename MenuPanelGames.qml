import QtQuick 2.0
import QtQuick.Layouts 1.1

import "global.js" as Global
import "menupanel.js" as Panel


Item {

    id: games

    signal getNewImage


    property bool horizontalLayout: parent.width > parent.height
    property real sideRatio: parent.width / parent.height

    property int type

    signal startGame10x15
    signal startGame20x15
    signal startGame20x30
    signal startGame40x30


    x:horizontalLayout ? (parent.width / 2 - width) / 2 : parent.width * 1 / 15
    y: horizontalLayout ? parent.height * 1 / 15 : (parent.height / 2 - height) / 3
    width:  horizontalLayout ? Math.min(parent.width, parent.height) / 2 : parent.width - 2 * parent.width / 15
    height: horizontalLayout ? parent.height * 3.5 / 5 : Math.min(parent.height, parent.width) / 1.8

    PushButton {
        id: img1

        source: Global.spritePath+"btnGame1a.png"
        width: horizontalLayout ? Math.min(parent.width, parent.height) / 3 : Math.min(parent.width, parent.height) / 2.8
        height: width * originalSize.height / originalSize.width
        x: horizontalLayout ? parent.width * 1 / 3 + width / 2 : 0
        y: horizontalLayout ? 0 : parent.height * 1 / 3 + height / 2

        onClicked: startGame10x15
    }

    PushButton {
        id: img2

        source: Global.spritePath+"btnGame2a.png"
        width: img1.width
        height: img1.height
        x: horizontalLayout ? 0 + width / 2 : (parent.width - 4 * width) / 3 + width
        y: horizontalLayout ? (parent.height - 4 * height) / 3 + height : height / 2

        onClicked: startGame20x15

    }

    PushButton {
        id: img3

        source: Global.spritePath+"btnGame3a.png"
        width: img1.width
        height: img1.height
        x: horizontalLayout ? img2.x : parent.width - 2 * width - (parent.width - 4 * width) / 3
        y: horizontalLayout ? parent.height - 2 *  height - (parent.height - 4 * height) / 3 : img2.y

        onClicked: startGame20x30

    }

    PushButton {
        id: img4

        source: Global.spritePath+"btnGame4a.png"
        width: img1.width
        height: img1.height
        x: horizontalLayout ? img1.x : parent.width - width
        y: horizontalLayout ? parent.height - height : img1.y

        onClicked: startGame40x30
    }

    BetterImage {
        id: piece

        preserveAspectRatio: true
        width: Math.min(parent.width, parent.height) / 3
        height: width * originalSize.height / originalSize.width
        x: horizontalLayout ? parent.width - width : (parent.width - width) / 2
        y: horizontalLayout ? (parent.height - height) / 2 : parent.height - height * 1.5

        BetterImage {
            id: face

            preserveAspectRatio: true
            visible: false
        }
    }


    onGetNewImage: Panel.newFaceImage()
}
