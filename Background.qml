import QtQuick 2.0


import "background.js" as Background


Item {
    id: background

    anchors.fill: parent
    Component.onCompleted: Background.create();
}
