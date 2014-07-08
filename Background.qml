import QtQuick 2.0


import "background.js" as Background


Item {
    id: background

    anchors.fill: parent

    onWidthChanged: Background.resize();
    onHeightChanged: Background.resize();

    Component.onCompleted: Background.create();
}
