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

//code signoff date: 2014-08-21
Item {
    id: panelInputs

    property alias playerName:                  textFieldItem.text
    property alias roomNumber:                  textFieldItem2.text
    property bool isRoomNumberValid:            false

    Column {
        anchors.fill:                           parent

        Rectangle {
            id:                                 inputName
            width:                              parent.width
            height:                             menuPanel.titleHeight
            radius:                             titleRadius
            color:                              menuPanel.color

            Item {
                id:                             textField
                x:                              parent.width - width
                height:                         parent.height
                width:                          inputName.width / 1.8

                TextField {
                    id:                         textFieldItem
                    text:                       playerName

                    x:                          (parent.width - width) / 2
                    y:                          (parent.height - height) / 2
                    width:                      parent.width * 0.9
                    height:                     parent.height * 0.8
                    font.pixelSize:             titleFontSize
                    font.bold:                  true
                    antialiasing:               true
                    smooth:                     true

                    style: TextFieldStyle {
                        textColor:              inputNameLabel.color
                        background: Rectangle {
                            color:              menuPanel.color
                            radius:             textFieldItem.height / 5
                            border.color:       "#cccccc"
                            border.width:       menuPanel.isLandscapeLayout ? textFieldItem.height / 15 : textFieldItem.height / 20
                        }
                    }

                    onTextChanged:              Board.changePlayerName(textFieldItem.text);
                }
            }

            Text {
                id:                             inputNameLabel
                text:                           qsTr("Your Name:")

                color:                          "white"
                anchors.right:                  textField.left
                anchors.verticalCenter:         inputName.verticalCenter
                font:                           textFieldItem.font
                antialiasing:                   true
                smooth:                         true
            }

        }

        Rectangle {
            id:                                 inputRoomNr
            width:                              parent.width
            height:                             menuPanel.titleHeight
            radius:                             titleRadius
            color:                              menuPanel.color

            Item {
                id:                             textField2
                x:                              parent.width - width
                height:                         parent.height
                width:                          inputRoomNr.width / 1.8

                TextField {
                    id:                         textFieldItem2

                    x:                          (parent.width - width) / 2
                    y:                          (parent.height - height) / 2
                    width:                      parent.width * 0.9
                    height:                     parent.height * 0.8
                    font:                       textFieldItem.font
                    antialiasing:               true
                    smooth:                     true

                    style: TextFieldStyle {
                        textColor:              inputNameLabel.color
                        background: Rectangle {
                            color:              menuPanel.color
                            radius:             textFieldItem.height / 5
                            border.color:       "#cccccc"
                            border.width:       menuPanel.isLandscapeLayout ? textFieldItem.height / 15 : textFieldItem.height / 20
                        }
                    }

                    onTextChanged:              isRoomNumberValid = Board.changeRoomNumber()
                }
            }

            Text {
                id:                             roomNumberLabel
                text:                           qsTr("Room #:")
                color:                          isRoomNumberValid ? inputNameLabel.color : "#ff1111"

                anchors.right:                  textField2.left
                anchors.verticalCenter:         inputRoomNr.verticalCenter

                font.pixelSize:                 textFieldItem.font.pixelSize
                font.bold:                      true
                font.strikeout:                 !isRoomNumberValid
                antialiasing:                   true
                smooth:                         true
            }

            PushButton {
                source:                            "/images/sprites/new_room.png"

                anchors.verticalCenter:         inputRoomNr.verticalCenter
                height:                         parent.height * 0.7
                width:                          height
                anchors.right:                  roomNumberLabel.left
                anchors.rightMargin:            height / 2
                onClicked:                      {
                    textFieldItem2.text = Board.generateRoomNumber()

                }
            }
        }
    }
}
