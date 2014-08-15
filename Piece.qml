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
  */
Item {
    id: piece

    property int index
    readonly property int indexX:   index % board.nx
    readonly property int indexY:   Math.floor(index / board.nx)

    property int color: 0
    property int shape: 0
    property alias source: sprite.source
    property alias mouseArea: mouseArea

    property bool isSelected: false
    property int  selectionID: 0
    property bool xAnimationEnabled: false
    property bool isDestroying: false

    property alias shineAnimation: shine

    signal mouseClicked(int index)
    signal mouseEntered(int index)
    signal mouseExited(int index)

    signal destroyPiece
    signal pieceDestroyed(int index)

    Component.onCompleted: Piece.create();

    onIsSelectedChanged: Piece.onSelectionChange();

    width: Math.min(board.width / board.nx, board.height / board.ny)
    height: width
    x: indexX * width
    y: board.height - (board.ny - indexY) * height

    Rectangle {
        id: spriteRect;
        anchors.fill: parent
        border.color: "black";
        color: "white"
        scale: 0.95
        visible: false;

    }

    BetterImage {
        id: sprite
        anchors.fill: parent
    }



    onSourceChanged: Piece.setScale()
    onWidthChanged: Piece.setScale()
    onHeightChanged: Piece.setScale()

    BetterImage {
        id: shiningStar
        width: parent.width / 2
        height: parent.height / 2
        opacity: 0
        source: Global.spritePath+"shine.png"
        z: 1
    }

    Behavior on x {
        enabled: xAnimationEnabled;
        NumberAnimation {
            easing {
                type: Easing.OutElastic
                amplitude: 1
                period: 1.5
            }
            duration: 1000
        }
    }

    Behavior on y {
        NumberAnimation {
            easing {
                type: Easing.OutElastic
                amplitude: 1
                period: 1.5
            }
            duration: 1000
        }
    }


    SequentialAnimation {
        id: shine;
        loops: 1;

        property int delay: Math.random() * 10000;
        property int duration: Math.random() * 400 + 200;


        PropertyAnimation { duration: shine.delay; }

        ParallelAnimation {
            SequentialAnimation {
                NumberAnimation {
                         target: shiningStar
                         properties: "opacity"
                         from: 0
                         to: 0.8
                         duration: shine.duration
                         easing {type: Easing.InOutBounce}
                }
                NumberAnimation {
                         target: shiningStar
                         properties: "opacity"
                         from: 0.8
                         to: 0
                         duration: shine.duration
                         easing {type: Easing.InOutBounce}
                }
            }
            NumberAnimation {
                     target: shiningStar
                     properties: "scale"
                     from: 0
                     to: 0.6
                     duration: 2 * shine.duration
                     easing {type: Easing.InOutBounce}
            }
        }

        onStopped: {
            shine.delay = Math.random() * 10000;
            shine.duration = Math.random() * 400 + 200
            shine.start();
        }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: !PlatformDetails.isMobile;
        onEntered:    if(!PlatformDetails.isMobile) mouseEntered(index);
        onExited:     if(!PlatformDetails.isMobile) mouseExited(index);
        cursorShape:  Qt.PointingHandCursor

        onClicked:  mouseClicked(index);
    }

    onDestroyPiece: {
        destroyAnimation.start()
    }

    SequentialAnimation {

        id: destroyAnimation;
        loops: 1;


        NumberAnimation {
                 target: piece
                 properties: "scale"
                 from: 1
                 to: 1.1
                 duration: Math.random() * 100
                 easing {type: Easing.OutQuad}
        }

         ParallelAnimation {

             ScriptAction {
                 script: particles.burst(50);
            }

            NumberAnimation {
                     target: piece
                     properties: "scale"
                     from: 1.1
                     to: 0
                     duration: 300
                     easing {type: Easing.InQuad}
            }
        }

         onStarted: isDestroying = true;
         onStopped: pieceDestroyed(index);
    }

    ParticleSystem {
        id: particleSystem

        anchors.centerIn: parent
        ImageParticle {
            source: Global.spritePath + "piece_color_"+ piece.color + "_dust.png"
            rotationVelocityVariation: 360
        }

        Emitter {
            id: particles
            anchors.centerIn: parent
            emitRate: 0
            lifeSpan: 400
            velocity: AngleDirection {angleVariation: 360; magnitude: piece.width * 5; magnitudeVariation: piece.width}
            size: piece.width / 2
        }
    }

}
