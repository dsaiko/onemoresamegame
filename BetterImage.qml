/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0


Item {
    id: betterImage

    property alias source:              image.source
    property bool  preserveAspectRatio: false
    property alias originalSize:        backupImage.sourceSize

    //this should be better than scaling of the image
    property real margin:       0
    property real marginLeft:   0
    property real marginRight:  0
    property real marginTop:    0
    property real marginBottom: 0

    width: height * backupImage.sourceSize.width / backupImage.sourceSize.height
    //height: width * backupImage.sourceSize.height / backupImage.sourceSize.width

    Image {
        id: image

        sourceSize.width:  parent.width * ( 1 - (margin + marginLeft + marginRight))
        sourceSize.height: parent.height * ( 1 - (margin + marginTop + marginBottom))

        height: sourceSize.height
        width: sourceSize.width
        x: parent.width * (margin + 2*marginLeft) / 2.0
        y: parent.height * (margin + 2*marginTop) / 2.0

        fillMode: preserveAspectRatio ? Image.PreserveAspectFit : Image.Stretch
    }

    Image {
        id: backupImage
        visible: false;
        source: image.source
    }
}
