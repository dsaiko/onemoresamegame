/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "global.js" as Global
import "menupanel.js" as Panel
import "board.js" as Board

Item {

    id: games

    property bool horizontalLayout: parent.width > parent.height
    property real sideRatio: parent.width / parent.height
    property alias playerName: textFieldItem.text
    property alias roomNumber: textFieldItem2.text
    property bool isRoomNumberValid: false

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
        id: inputName
        width: parent.width
        height: headerHeight
        x: 0
        y: 0
        radius: Math.min(width, height) / 8
        color: Qt.rgba(0.2, 0.2, 0.2, 0.8)

        Item {
            id: textField
            x: parent.width - width
            height: parent.height
            width: inputName.width / 1.8

            TextField {
                id: textFieldItem

                width: parent.width * 0.9
                height: parent.height * 0.8
                font.pixelSize: Math.floor(Math.min(height, width * 0.19) * 0.5)
                font.bold: true
                antialiasing: true
                smooth: true
                text: playerName

                x: (parent.width - width) / 2
                y: (parent.height - height) / 2

                style: TextFieldStyle {
                    textColor: inputNameLabel.color
                    background: Rectangle {
                        color: Qt.rgba(0.2, 0.2, 0.2, 0.8)
                        radius: textFieldItem.height / 5
                        border.color: "#cccccc"
                        border.width: horizontalLayout? textFieldItem.height / 15 : textFieldItem.height / 20
                    }
                }

                onTextChanged: Board.changePlayerName(textFieldItem.text);
            }

        }

        Text {
            id: inputNameLabel
            text: qsTr("Your Name:")

            color: Qt.rgba(0.9, 0.9, 0.9, 1)

            anchors.right: textField.left
            anchors.verticalCenter: inputName.verticalCenter

            font:textFieldItem.font

            antialiasing: true
            smooth: true
            style: Text.Raised
            styleColor: "transparent"
            textFormat: Text.StyledText

        }

    }

    Rectangle {
        id: inputRoomNr
        width: inputName.width
        height: inputName.height
        x: 0
        y: inputName.height
        radius: inputName.radius
        color: inputName.color

        Item {
            id: textField2
            x: parent.width - width
            height: parent.height
            width: inputRoomNr.width / 1.8

            TextField {
                id: textFieldItem2

                width: parent.width * 0.9
                height: parent.height * 0.8
                font:textFieldItem.font
                antialiasing: true
                smooth: true

                x: (parent.width - width) / 2
                y: (parent.height - height) / 2

                style: TextFieldStyle {
                    textColor: inputNameLabel.color
                    background: Rectangle {
                        color: Qt.rgba(0.2, 0.2, 0.2, 0.8)
                        radius: textFieldItem.height / 5
                        border.color: "#cccccc"
                        border.width: horizontalLayout? textFieldItem.height / 15 : textFieldItem.height / 20
                    }
                }

                onTextChanged: isRoomNumberValid = Board.changeRoomNumber()
            }

        }

        Text {
            id: roomNumberLabel
            text: qsTr("Room #:")
            color: isRoomNumberValid ? inputNameLabel.color : "#ff1111"

            anchors.right: textField2.left
            anchors.verticalCenter: inputRoomNr.verticalCenter

            font.pixelSize: textFieldItem.font.pixelSize
            font.bold: true
            font.strikeout: !isRoomNumberValid

            antialiasing: true
            smooth: true
            style: Text.Raised
            styleColor: "transparent"
            textFormat: Text.StyledText

        }
    }

    Rectangle {
        id: header
        width: parent.width
        height: headerHeight
        x: 0
        y: inputRoomNr.y + inputRoomNr.height * 1.1
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
        y: header.y + header.height

        PushButton {
            id: img1
            opacity: 0.8

            source: Global.spritePath+"btnGame1a.png"
            width: horizontalLayout ? Math.min(parent.width, parent.height) / 3 : Math.min(parent.width / 4, parent.height * originalSize.width / originalSize.height) * 0.9
            height: width * originalSize.height / originalSize.width
            x:  horizontalLayout ? (parent.width - 2 * width) / 3 : (parent.width - 4 * width) / 5
            y: horizontalLayout ? (parent.height - 3 * height) : (parent.height - height) / 2

            onClicked: startGame10x15()
        }

        PushButton {
            id: img2
            opacity: 0.7

            source: Global.spritePath+"btnGame2a.png"
            width: img1.width
            height: img1.height
            x:  horizontalLayout ? (parent.width - 2 * width) * 2 / 3 + width : img1.x + width + img1.x
            y:  img1.y

            onClicked: startGame20x15()

        }

        PushButton {
            id: img3
            opacity: 0.7

            source: Global.spritePath+"btnGame3a.png"
            width: img1.width
            height: img1.height
            x:  horizontalLayout ? img1.x : img2.x + width + img1.x
            y: horizontalLayout ? (parent.height - 1.5 * height) : img1.y

            onClicked: startGame20x30()

        }

        PushButton {
            id: img4
            opacity: 0.7

            source: Global.spritePath+"btnGame4a.png"
            width: img1.width
            height: img1.height
            x: horizontalLayout ? img2.x : img3.x + width + img1.x
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
