import QtQuick 2.0

Rectangle {

    readonly property real rndSizeX: Math.random()
    readonly property real rndSizeY: Math.random()
    property real suggestedWidth: rndSizeX * parent.width / 10 + parent.width / 30
    property real suggestedHeight: rndSizeY * parent.height / 10 + parent.height / 30

    width:  Math.min(suggestedWidth, suggestedHeight)
    height:  Math.min(suggestedWidth, suggestedHeight)


    readonly property real rndX: Math.random()
    readonly property real rndY: Math.random()
    x: rndX * parent.width - width / 2
    y: rndY * parent.height - height / 2

    color: Qt.rgba(Math.random() * 0.2, Math.random() * 0.2, Math.random() * 0.2)
    opacity: Math.random() * 0.2
}
