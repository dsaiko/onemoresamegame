import QtQuick 2.0
import QtQuick.Particles 2.0

import "global.js" as Global
import "piece.js" as Piece

Item {
    id: piece

    property int pieceIndex: -1
    readonly property int color: Piece.color;

    property bool isSelected: false
    property int  selectionID: 0
    property bool xAnimationEnabled: false
    property bool isDestroying: false

    signal mouseClicked(int pieceIndex)
    signal mouseEntered(int pieceIndex)
    signal mouseExited(int pieceIndex)

    signal destroyPiece
    signal pieceDestroyed(int pieceIndex)

    Component.onCompleted: Piece.create();

    onIsSelectedChanged: Piece.onSelectionChange();

    Image {
        id: shiningStar
        width: parent.width
        height: parent.height
        x: - parent.width / 5
        y: - parent.height / 5
        opacity: 0
        smooth: true
        source: Global.spritePath+"star.png"
        z: 1
    }

    Behavior on y {
        SpringAnimation{
            spring: 4;
            damping: 0.3
        }
    }

    Behavior on x {
        enabled: xAnimationEnabled;
        SpringAnimation{
            spring: 2;
            damping: 0.2
        }
    }

    SequentialAnimation {
        id: animation;
        loops: Animation.Infinite;

        PropertyAnimation {
            duration: 30;
        }

        ScriptAction {
            script: Piece.rotateSprite();
        }

        onStopped: {
            stopAnimation.start()
        }

        onStarted: {
            stopAnimation.stop()
        }

    }

    SequentialAnimation {
        id: stopAnimation;
        loops: 4;
        PropertyAnimation {
            duration: 40;
        }

        ScriptAction {
            script: Piece.rotateSprite();
        }
    }



    SequentialAnimation {
        id: shine;
        loops: 1;

        property int delay: Math.random() * 5000; // * 60 + 10000;
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
            shine.delay = Math.random() * 5000;
            shine.duration = Math.random() * 400 + 200;
            shine.start();
        }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: !PlatformDetails.isMobile;
        onEntered:    if(!PlatformDetails.isMobile) mouseEntered(pieceIndex);
        onExited:     if(!PlatformDetails.isMobile) mouseExited(pieceIndex);

        onClicked:  mouseClicked(pieceIndex);
    }

    onDestroyPiece: {
        animation.stop()
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
         onStopped: pieceDestroyed(pieceIndex);
    }

    ParticleSystem {
        id: particleSystem

        anchors.centerIn: parent
        ImageParticle {
            source: Global.spritePath + Piece.color + "_dust.png"
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
