/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtGraphicalEffects 1.0
import QtQuick.LocalStorage 2.0 as Sql


import "global.js" as Global
import "menupanel.js" as Panel
import "board.js" as Board
import "db.js" as DB

//code signoff date: 2014-08-17

Item {
    id: score
    x:                                                      horizontalLayout ? parent.width / 2  + width * 0.01: parent.width * 1 / 15
    y:                                                      horizontalLayout ? parent.height * 1 / 20 : panelButtons.topY - height * 1.025
    width:                                                  horizontalLayout ? Math.min(Math.min(parent.width, parent.height) * 0.8, parent.width / 2.1) : parent.width - 2 * parent.width / 15
    height:                                                 horizontalLayout ? parent.height * 3.5 / 5 + parent.height * 1 / 30 : (panelButtons.topY * 0.62 )
    clip:                                                   true

    readonly property bool horizontalLayout:                parent.width > parent.height
    property alias headerHeight:                            header.height
    property alias scoreModel:                              scoreModel


    Rectangle {
        id:                                                 header
        width:                                              parent.width
        height:                                             horizontalLayout ? parent.height / 13 : parent.height / 10
        radius:                                             Math.min(width, height) / 8
        color:                                              Qt.rgba(0.2, 0.2, 0.2, 0.8)

        Text {
            text:                                           qsTr("Top Scores:")
            color:                                          Qt.rgba(0.9, 0.9, 0.9, 1)
            x:                                              parent.height / 2
            anchors.verticalCenter:                         parent.verticalCenter
            font.pixelSize:                                 Math.floor(Math.min(parent.height * 0.8, parent.width * 0.9 * 0.19) * 0.5)
            font.bold:                                      true
            antialiasing:                                   true
            smooth:                                         true
        }
    }


    Rectangle {
        id:                                                 scoreTable
        width:                                              header.width
        height:                                             parent.height - y
        radius:                                             header.radius
        color:                                              header.color
        y:                                                  header.visible ? header.y + header.height : header.y

        readonly property real rowHeight:                   horizontalLayout ? Math.min(height, width) / 20 : Math.min(height, width) / 16

        ListModel {
                id:                                         scoreModel
        }

        Column {
            Repeater {
                model:                                      16
                Rectangle {
                    radius:                                 height / 8
                    color:                                  "transparent"

                    LinearGradient {
                            visible:                        sectionHeader.visible
                            anchors.fill:                   parent
                            start:                          Qt.point(0, 0)
                            end:                            Qt.point(parent.height * 2, parent.height / 4)
                            gradient: Gradient {
                                GradientStop {
                                                            position: 0.0;
                                                            color: Qt.rgba(1,1,1,0.7)
                                }
                                GradientStop {
                                                            position: 1.0;
                                                            color: "transparent"
                                }
                            }
                        }


                    height:                                 scoreTable.rowHeight
                    width:                                  scoreTable.width * 0.95
                    x:                                      (scoreTable.width - width) / 2

                    property int headerIndex:               Math.floor(index / 4) * 3
                    property int dataIndex:                 index - Math.floor(index / 4) - 1
                    property string header:                 (scoreModel.count > headerIndex) ? scoreModel.get(headerIndex).board : "?"


                    property var rowData:                   (scoreModel.count > dataIndex) ? scoreModel.get(dataIndex) : null

                    Text {
                        id:                                 sectionHeader
                        visible:                            index % 4 == 0 && (scoreModel.count > headerIndex)

                        anchors.verticalCenter:             parent.verticalCenter

                        text:                               " "+ header
                        font.bold:                          true
                        font.pixelSize:                     scoreTable.rowHeight * 0.6
                        color:                              "#000000"
                        horizontalAlignment:                Text.AlignHCenter
                    }

                    Row {
                        id:                                 dataRow
                        visible:                            index % 4 != 0
                        anchors.fill:                       parent

                        Text {
                            text:                           (!rowData) ? "" : "#"+rowData.place
                            anchors.verticalCenter:         parent.verticalCenter
                            color:                          "#ffffff"
                            font.pixelSize:                 scoreTable.rowHeight * 0.6
                            antialiasing:                   true
                            smooth:                         true
                            width:                          parent.width * 0.1
                        }
                        Text {
                            text:                           (!rowData) ? "" : rowData.name
                            anchors.verticalCenter:         parent.verticalCenter
                            color:                          "#ffffff"
                            font.pixelSize:                 scoreTable.rowHeight * 0.6
                            antialiasing:                   true
                            smooth:                         true
                            width:                          parent.width * 0.34
                        }
                        Text {
                            text:                           (!rowData) ? "" : Global.number_format(rowData.score)
                            anchors.verticalCenter:         parent.verticalCenter
                            horizontalAlignment:            Text.AlignRight
                            color:                          "#ffffff"
                            font.pixelSize:                 scoreTable.rowHeight * 0.6
                            antialiasing:                   true
                            smooth:                         true
                            width:                          parent.width * 0.2
                        }
                         Text {
                            text:                           (!rowData) ? "" : rowData.level
                            anchors.verticalCenter:         parent.verticalCenter
                            horizontalAlignment:            Text.AlignRight
                            color:                          "#ffffff"
                            font.pixelSize:                 scoreTable.rowHeight * 0.6
                            antialiasing:                   true
                            smooth:                         true
                            width:                          parent.width * 0.11
                        }
                        Text {
                            text:                           (!rowData) ? "" : rowData.date
                            anchors.verticalCenter:         parent.verticalCenter
                            horizontalAlignment:            Text.AlignRight
                            color:                          "#ffffff"
                            font.pixelSize:                 scoreTable.rowHeight * 0.6
                            antialiasing:                   true
                            smooth:                         true
                            width:                          parent.width * 0.25

                        }
                    }
                }
            }
            Component.onCompleted:                          DB.reloadScore()
        }
    }
}
