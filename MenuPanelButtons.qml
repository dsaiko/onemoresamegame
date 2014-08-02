import QtQuick 2.0
import QtQuick.Layouts 1.1

import "global.js" as Global
import "menupanel.js" as Panel

Item {
    id: buttons

    property bool horizontalLayout: parent.width > parent.height
    property real sideRatio: parent.width / parent.height
    property real centerX: width / 2
    property real topY: btn1.y



    property real spacing: btn1.height * 2.5 / 3

    Item {
        height: parent.height
        x: horizontalLayout ?  (width - (btn1.width + btn2.width + btn3.width + 3 * spacing)) / 2: 0
        width: parent.width

        PushButton {
            id: btn1

            width: horizontalLayout ? Math.min(buttons.width / 3, buttons.height / 3) : Math.min(buttons.parent.width * 0.9, (buttons.width / 2) / (sideRatio * 1.3))
            height: width * originalSize.height / originalSize.width

            y: horizontalLayout ? btn2.y : btn2.y - 1.2 * height
            x: horizontalLayout ? spacing : centerX - width / 2


            source: Global.spritePath+"btnMenuScores.png"
            text:qsTr("Sync Scores")
        }

        PushButton {
            id: btn2

            height: btn1.height
            width: height * originalSize.width / originalSize.height

            y: horizontalLayout ? btn3.y : btn3.y - 1.2 * height
            x: horizontalLayout ? btn1.x + btn1.width + spacing : centerX - width / 2

            source: Global.spritePath+"btnMenuUpdates.png"
            text:qsTr("Check Updates")
        }

        PushButton {
            id: btn3

            height: btn1.height
            width: height * originalSize.width / originalSize.height

            y: parent.height - 2 * height
            x: horizontalLayout ? btn2.x + btn2.width + spacing : centerX - width / 2

            source: Global.spritePath+"btnMenuQuit.png"
            text:qsTr("Quit")

            onClicked: Qt.quit()
        }
    }
}
