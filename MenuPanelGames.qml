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
    id:                                             games

    signal startGame10x15
    signal startGame20x15
    signal startGame20x30
    signal startGame40x30

    Rectangle {
        id:                                         header
        width:                                      parent.width
        height:                                     titleHeight
        radius:                                     titleRadius
        color:                                      menuPanel.color

        Text {
            text:                                   qsTr("Start a New Game:")

            color:                                  "white"

            x:                                      parent.height / 2
            anchors.verticalCenter:                 parent.verticalCenter

            font.pixelSize:                         titleFontSize
            font.bold:                              true
            antialiasing:                           true
            smooth:                                 true
        }

    }

    Rectangle {
        radius:                                     titleRadius
        color:                                      menuPanel.color
        width:                                      parent.width
        y:                                          header.height
        height:                                     parent.height - y

        PushButton {
            id:                                     img1
            source:                                 Global.spritePath+"btnGame1a.png"

            x:                                      isLandscapeLayout ? (parent.width - width)/ 2 : (parent.width - 4 * width) / 5
            y:                                      isLandscapeLayout ? (parent.height - 4 * height) / 5 : (parent.height - height) / 2
            width:                                  isLandscapeLayout ? Math.min(parent.width * 1.3, parent.height * 0.9) / 2.7 : Math.min(parent.width / 4, parent.height * aspectRatio) * 0.9

            opacity:                                0.8
            onClicked:                              startGame10x15()
        }

        PushButton {
            id:                                     img2
            source:                                 Global.spritePath+"btnGame2a.png"

            x:                                      isLandscapeLayout ? img1.x : img1.x + width + img1.x
            y:                                      isLandscapeLayout ? img1.y + height + img1.y : img1.y
            width:                                  img1.width

            opacity:                                0.8
            onClicked:                              startGame20x15()
        }

        PushButton {
            id:                                     img3
            source:                                 Global.spritePath+"btnGame3a.png"

            x:                                      isLandscapeLayout ? img1.x : img2.x + width + img1.x
            y:                                      isLandscapeLayout ? img2.y + height + img1.y : img1.y
            width:                                  img1.width

            opacity:                                0.8
            onClicked: startGame20x30()
        }

        PushButton {
            id:                                     img4
            source:                                 Global.spritePath+"btnGame4a.png"

            x:                                      isLandscapeLayout ? img2.x : img3.x + width + img1.x
            y:                                      isLandscapeLayout ? img3.y + height + img1.y : img3.y
            width:                                  img1.width

            opacity:                                0.8
            onClicked:                              startGame40x30()
        }
    }
}
