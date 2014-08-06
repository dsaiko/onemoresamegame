import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1


import "global.js" as Global
import "menupanel.js" as Panel
import "board.js" as Board

Item {

    id: score

    property bool horizontalLayout: parent.width > parent.height
    property real sideRatio: parent.width / parent.height

    property alias playerName: textFieldItem.text
    property alias headerHeight: inputName.height


    x:horizontalLayout ? parent.width / 2  + width * 0.01: parent.width * 1 / 15
    y: horizontalLayout ? parent.height * 1 / 20 : panelButtons.topY - height * 1.025
    width:  horizontalLayout ? Math.min(Math.min(parent.width, parent.height) * 0.8, parent.width / 2.1) : parent.width - 2 * parent.width / 15
    height: horizontalLayout ? parent.height * 3.5 / 5 + parent.height * 1 / 30 : (panelButtons.topY * 0.6 )

    Rectangle {
        id: inputName
        width: parent.width
        height: horizontalLayout ? parent.height / 12 : parent.height / 8
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
            }

        }

        Text {
            text: qsTr("Room #:")
            color: inputNameLabel.color

            anchors.right: textField2.left
            anchors.verticalCenter: inputRoomNr.verticalCenter

            font:textFieldItem.font

            antialiasing: true
            smooth: true
            style: Text.Raised
            styleColor: "transparent"
            textFormat: Text.StyledText

        }
    }

    Rectangle {
        id: scoreTable
        width: inputName.width
        height: parent.height - y
        radius: inputName.radius
        color: inputName.color
        x: 0
        y: inputRoomNr.y + inputRoomNr.height * 1.1

        property real rowHeight: horizontalLayout ? Math.min(height, width) / 15 : Math.min(height, width) / 12

        ListModel {
           id: scoreModel
           ListElement{ place: "1" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "2" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "3" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "4" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "5" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "6" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "7" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "8" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "9" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
           ListElement{ place: "10" ;   score10x15: "?"; score20x15: "?"; score20x30: "?"; score40x30: "?"}
        }

        TableView {
            TableViewColumn{ role: "place"  ; title: "#" ; width: scoreTable.width * 0.1 }
            TableViewColumn{ role: "score10x15"  ; title: "10x15" ; width: scoreTable.width * 0.225 }
            TableViewColumn{ role: "score20x15"  ; title: "20x15" ; width: scoreTable.width * 0.225 }
            TableViewColumn{ role: "score20x30"  ; title: "20x30" ; width: scoreTable.width * 0.225 }
            TableViewColumn{ role: "score40x30"  ; title: "40x30" ; width: scoreTable.width * 0.225 }
            model: scoreModel

            anchors.fill: parent
            backgroundVisible: false
            alternatingRowColors: false
            frameVisible: false

            itemDelegate: Item {
                height: scoreTable.rowHeight

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    color: "#ffffff"
                    text: styleData.value

                    font.pixelSize: scoreTable.rowHeight * 0.6

                    antialiasing: true
                    smooth: true
                }
            }

            rowDelegate: Item {
                height: scoreTable.rowHeight
            }

            headerDelegate: Item {
                height: scoreTable.rowHeight

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "#ffffff"
                    text: styleData.value

                    font.pixelSize: scoreTable.rowHeight * 0.7
                    font.bold: true

                    antialiasing: true
                    smooth: true
                    style: Text.Raised
                    styleColor: "transparent"
                    textFormat: Text.StyledText
                }
            }


        }

    }
}
