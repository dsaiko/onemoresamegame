import QtQuick 2.0
import QtQuick.Layouts 1.1

import "global.js" as Global
import "menupanel.js" as Panel


Rectangle {

    id: games

    property bool horizontalLayout: parent.width > parent.height
    property real sideRatio: parent.width / parent.height


    x:0
    y: horizontalLayout ? parent.height * 1 / 15 : 0
    width:  horizontalLayout ? parent.width / 2 : parent.width
    height: horizontalLayout ? parent.height * 4 / 5 : parent.height / 2.5


}
