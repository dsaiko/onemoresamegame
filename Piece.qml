/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

import QtQuick 2.0
import QtQuick.Particles 2.0
import "global.js" as Global
import "piece.js" as Piece

/**
  * Board piece item
  *
  * code signoff date: 2014-08-15
  */
Item {
    id: piece

    width:                              Math.min(parent.width / boardGridWidth, parent.height / boardGridHeight)
    height:                             width
    x:                                  indexX * width
    y:                                  parent.height - (boardGridHeight - indexY) * height

    property int index
    readonly property int indexX:       index % boardGridWidth
    readonly property int indexY:       Math.floor(index / boardGridWidth)

    property int color:                 0
    property int shape:                 0

    property alias source:              sprite.source

    //flag if piece is selected
    property bool isSelected:           false
    //selection id - to be sure we process only what we have selected (vs fast clicking etc)
    property int  selectionID:          0

    //is animation of x property enabled? no for spawning new sets
    property bool xAnimationEnabled:    false

    //if true, piece is playing destroy animation
    property bool isDestroying:         false

    //to be able to stop shining when menu is on
    property alias shineAnimation:      shiningStar.shineAnimation

    signal mouseClicked(int index)
    signal mouseEntered(int index)
    signal mouseExited(int index)

    signal destroyPiece
    signal pieceDestroyed(int index)

    onShapeChanged:                     Piece.setScaleAndStarPosition()
    onWidthChanged:                     Piece.setScaleAndStarPosition()
    onHeightChanged:                    Piece.setScaleAndStarPosition()
    onDestroyPiece:                     destroyAnimation.start()

    //highlite rectangle
    Rectangle {
        anchors.fill:                   parent
        border.color:                   "black"
        color:                          "white"
        scale:                          0.95
        visible:                        isSelected && !isDestroying
    }

    //piece sprite
    BetterImage {
        id:                             sprite
        width:                          parent.width
    }


    PieceShiningStar {
        id:                             shiningStar
    }

    Behavior on x {
        enabled:                        xAnimationEnabled
        NumberAnimation {
            easing {
                type:                   Easing.OutElastic
                amplitude:              1
                period:                 1.5
            }
            duration:                   1000
        }
    }

    Behavior on y {
        NumberAnimation {
            easing {
                type:                   Easing.OutElastic
                amplitude:              1
                period:                 1.5
            }
            duration:                   1000
        }
    }


    MouseArea {
        anchors.fill:                   parent
        hoverEnabled:                   !PlatformDetails.isMobile
        onEntered:                      if(!PlatformDetails.isMobile) mouseEntered(index)
        onExited:                       if(!PlatformDetails.isMobile) mouseExited(index)
        cursorShape:                    Qt.PointingHandCursor

        onClicked:                      mouseClicked(index)
    }



    SequentialAnimation {
        id:                             destroyAnimation

        NumberAnimation {
                 target:                piece
                 properties:            "scale"
                 to: 1.1
                 duration:              Math.random() * 100
                 easing.type:           Easing.OutQuad
        }

        ParallelAnimation {
            ScriptAction {
                 script:                particles.burst(50)
            }
            NumberAnimation {
                     target:            piece
                     properties:        "scale"
                     to:                0
                     duration:          300
                     easing.type:       Easing.InQuad
            }
        }

        onStarted:                      isDestroying = true
        onStopped:                      pieceDestroyed(index)
    }

    ParticleSystem {
        anchors.centerIn:               parent
        ImageParticle {
            source:                     Global.spritePath + "piece_color_"+ piece.color + "_dust.png"
            rotationVelocityVariation:  360
        }

        Emitter {
            id:                         particles
            anchors.centerIn:           parent
            emitRate:                   0
            lifeSpan:                   400
            velocity:                   AngleDirection {angleVariation: 360; magnitude: piece.width * 5; magnitudeVariation: piece.width}
            size:                       piece.width / 2
        }
    }
}
