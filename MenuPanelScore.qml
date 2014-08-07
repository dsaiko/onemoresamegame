import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.LocalStorage 2.0 as Sql


import "global.js" as Global
import "menupanel.js" as Panel
import "board.js" as Board
import "db.js" as DB

Item {

    id: score

    property bool horizontalLayout: parent.width > parent.height
    property real sideRatio: parent.width / parent.height

    property alias headerHeight: header.height
    property alias scoreModel: scoreModel


    x:horizontalLayout ? parent.width / 2  + width * 0.01: parent.width * 1 / 15
    y: horizontalLayout ? parent.height * 1 / 20 : panelButtons.topY - height * 1.025
    width:  horizontalLayout ? Math.min(Math.min(parent.width, parent.height) * 0.8, parent.width / 2.1) : parent.width - 2 * parent.width / 15
    height: horizontalLayout ? parent.height * 3.5 / 5 + parent.height * 1 / 30 : (panelButtons.topY * 0.6 )

    Rectangle {
        id: header
        width: parent.width
        height: horizontalLayout ? parent.height / 13 : parent.height / 10
        x: 0
        y: 0
        radius: Math.min(width, height) / 8
        color: Qt.rgba(0.2, 0.2, 0.2, 0.8)

        Text {
            text: qsTr("Best Scores:")

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
           // visible: horizontalLayout

        }

    }


    Component {
        id: sectionHeading
        Rectangle {
            width: scoreTable.width
            height: childrenRect.height
            color: "#888888"
            radius: height / 8

            Text {
                text: " " + section
                font.bold: true
                font.pixelSize: scoreTable.rowHeight * 0.6
                color: "#000000"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Rectangle {
        id: scoreTable
        width: header.width
        height: parent.height - y
        radius: header.radius
        color: header.color
        x: 0
        y: header.visible ? header.y + header.height : header.y

        property real rowHeight: horizontalLayout ? Math.min(height, width) / 20 : Math.min(height, width) / 16

        ListModel {
           id: scoreModel

           Component.onCompleted: DB.reloadScore()
        }

        TableView {
            TableViewColumn{ role: "place"  ; title: "#" ; width: scoreTable.width * 0.1 }
            TableViewColumn{ role: "name"  ; title: qsTr("Name") ; width: scoreTable.width * 0.225 }
            TableViewColumn{ role: "score"  ; title: qsTr("Score") ; width: scoreTable.width * 0.225 }
            TableViewColumn{ role: "level"  ; title: qsTr("Level") ; width: scoreTable.width * 0.225 }
            TableViewColumn{ role: "date"  ; title: qsTr("Date") ; width: scoreTable.width * 0.225 }
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

                    font.pixelSize: scoreTable.rowHeight * 0.6
                    font.bold: true

                    antialiasing: true
                    smooth: true
                    style: Text.Raised
                    styleColor: "transparent"
                    textFormat: Text.StyledText
                }
            }

            section.property: "board"
            section.criteria: ViewSection.FullString
            section.delegate: sectionHeading

        }

    }
}
