/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0

/**
  * Image with better quality than stock QT Image component
  * you can set "width" or "preferredHeight" property, do not set "height" - that is computed automatically
  */
Image {
    property real preferredHeight

    property real aspectRatio
    fillMode:       Image.PreserveAspectFit

    onWidthChanged:             onAspectRatioChanged
    onPreferredHeightChanged:   onAspectRatioChanged
    Component.onCompleted:      aspectRatio = sourceSize.width / sourceSize.height

    onAspectRatioChanged: {
        if(aspectRatio != 0) {
            if(preferredHeight) {
                width = preferredHeight * aspectRatio
            }

            height = width / aspectRatio
            sourceSize.width = width
            sourceSize.height = height
        }
    }

}
