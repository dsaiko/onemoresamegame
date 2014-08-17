/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0
import "global.js" as Global

/**
  * Image with text support and push button effect
  *
  * code signoff date: 2014-08-15
  */
BetterImage {
    property alias text:                    textItem.text

    signal clicked

    MouseArea {
        anchors.fill:                       parent
        hoverEnabled:                       !PlatformDetails.isMobile
        cursorShape:                        Qt.PointingHandCursor
        onPressed:                          parent.scale = 0.9
        onReleased:                         parent.scale = 1
        onClicked:                          parent.clicked()
    }

    Behavior on y {
        PropertyAnimation {
            property:                       "y"
            duration:                       100
        }
    }
    Behavior on x {
        PropertyAnimation {
            property:                       "x"
            duration:                       100
        }
    }
    Behavior on scale {
        PropertyAnimation {
            property:                       "scale"
            duration:                       100
        }
    }


    Text {
        id:                                 textItem
        x:                                  parent.height * 1.2
        anchors.verticalCenter:             parent.verticalCenter

        font.pixelSize:                     Math.floor(parent.height * 2 / 3.5)
        font.bold:                          true

        //following probably does not have any effect,
        //trying to improve text quality
        antialiasing:                       true
        smooth:                             true
        style:                              Text.Raised
        styleColor:                         "transparent"
        textFormat:                         Text.StyledText
    }
}
