import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "global.js" as Global
import "menupanel.js" as Panel


Item {

    id: games

    property bool horizontalLayout: parent.width > parent.height
    property real sideRatio: parent.width / parent.height

    property int type

    signal startGame10x15
    signal startGame20x15
    signal startGame20x30
    signal startGame40x30

    signal getNewImage

    x:horizontalLayout ? parent.width / 2 - width * 1.01 : parent.width * 1 / 15
    y: horizontalLayout ? parent.height * 1 / 20 : ((panelButtons.topY * 0.4 ) - height) / 2
    width:  horizontalLayout ? Math.min(Math.min(parent.width, parent.height) * 0.8, parent.width / 2.1) : parent.width - 2 * parent.width / 15
    height: horizontalLayout ? parent.height * 3.5 / 5 + parent.height * 1 / 30 : (panelButtons.topY * 0.36 )


    Rectangle {
        id: header
        width: parent.width
        height: headerHeight
        x: 0
        y: 0
        radius: Math.min(width, height) / 8
        color: Qt.rgba(0.2, 0.2, 0.2, 0.8)

        Text {
            text: qsTr("Start a New Game:")

            color: Qt.rgba(0.9, 0.9, 0.9, 1)

            x: parent.height / 2
            anchors.verticalCenter: parent.verticalCenter

            font.pixelSize: Math.floor(Math.min(parent.height * 0.8, parent.width * 0.9 * 0.19) * 0.5)
            font.bold: true

            antialiasing: true
            smooth: true
            style: Text.Raised
            styleColor: "transparent"
            textFormat: Text.StyledText

        }

    }



    Rectangle {

        radius: header.radius
        color: header.color
        width: parent.width
        height: parent.height - y
        x: 0
        y: header.height

        PushButton {
            id: img1
            opacity: 0.8

            source: Global.spritePath+"btnGame1a.png"
            width: horizontalLayout ? Math.min(parent.width, parent.height) / 3 : Math.min(Math.min(parent.width, parent.height) / 1.5, parent.width / 2.3)
            height: width * originalSize.height / originalSize.width
            x:  horizontalLayout ? (parent.width - 2 * width) / 3 : parent.width / 2 - width * 1.1
            y: horizontalLayout ? (parent.height - 3 * height) : (parent.height / 2 - height * 1.1)

            onClicked: startGame10x15()
        }

        PushButton {
            id: img2
            opacity: 0.7

            source: Global.spritePath+"btnGame2a.png"
            width: img1.width
            height: img1.height
            x:  horizontalLayout ? (parent.width - 2 * width) * 2 / 3 + width : parent.width / 2 + width * 0.1
            y:  img1.y

            onClicked: startGame20x15()

        }

        PushButton {
            id: img3
            opacity: 0.7

            source: Global.spritePath+"btnGame3a.png"
            width: img1.width
            height: img1.height
            x:  img1.x
            y: horizontalLayout ? (parent.height - 1.5 * height) : (parent.height /2 + height * 0.1)

            onClicked: startGame20x30()

        }

        PushButton {
            id: img4
            opacity: 0.7

            source: Global.spritePath+"btnGame4a.png"
            width: img1.width
            height: img1.height
            x:  img2.x
            y: img3.y

            onClicked: startGame40x30()
        }

        BetterImage {
            id: piece
            opacity: 0.7

            preserveAspectRatio: true
            width: horizontalLayout ? Math.min(parent.width, parent.height) / 3 : Math.min(parent.width, parent.height) / 3.2
            height: width * originalSize.height / originalSize.width
            x: (parent.width - width) / 2
            y:  (img1.y - height) / 2
            visible: horizontalLayout

            BetterImage {
                id: face

                preserveAspectRatio: true
                visible: false
            }
        }
    }

    onGetNewImage: Panel.newFaceImage()
}
