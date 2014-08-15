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
  *
  * code signoff date: 2014-08-15
  */
Image {
    property real preferredHeight
    property real aspectRatio

    signal          reComputeWidth
    fillMode:       Image.PreserveAspectFit
    smooth:         true
    antialiasing:   true

    onWidthChanged:             reComputeWidth()
    onPreferredHeightChanged:   reComputeWidth()
    onAspectRatioChanged:       reComputeWidth()
    Component.onCompleted:      aspectRatio = sourceSize.width / sourceSize.height

    onReComputeWidth:
    {
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
