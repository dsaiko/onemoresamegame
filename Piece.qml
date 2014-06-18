import QtQuick 2.2
import "global.js" as Global

Item {
    id: piece

    readonly property int color : Math.floor(Math.random() * 4)
    property var sprites: []
    property int rotation: -1
    property int spriteID: -1
    property bool isSelected: false
    property bool isCounted: false

    signal mouseEntered(int spriteID)
    signal mouseExited(int spriteID)
    signal mouseClicked(int spriteID)


    signal startAnimation
    signal stopAnimation

    onStartAnimation: {
        animation.start()
    }

    onStopAnimation: {
        animation.stop()
    }


    onRotationChanged: {
        var r = rotation % 8;

        sprites[r].visible = true;
        for(var i=0; i< sprites.length; i++) {
            if(i !== r) sprites[i].visible = false;
        }
    }

    onIsSelectedChanged: {
        if(isSelected) {
            animation.start();
        } else {
            animation.stop();
        }
    }

    Component {
        id: imageFactory
        Image{
            anchors.fill: piece
            visible: false
            smooth: true
        }
    }

    Image {
        id: star
        width: parent.width
        height: parent.height
        x: - parent.width / 5
        y: - parent.height / 5
        opacity: 0
        smooth: true
        source: Global.spritePath+"star.png"
        z: 1
    }

    Component.onCompleted: {
        for(var i=0; i<8; i++) {
            var image = imageFactory.createObject(this);
            image.source = Global.spritePath+color+"_"+i+".png";
            sprites.push(image);
        }


        rotation = Math.floor(Math.random() * 8)
        shine.start()
    }

    SequentialAnimation {
        id: animation;
        loops: Animation.Infinite;
        PropertyAnimation {
            duration: 30;
        }

        ScriptAction {
            script: { rotation ++;  }
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
            script: { rotation ++;  }
        }
    }



    SequentialAnimation {
        id: shine;
        loops: 1;

        property int delay: Math.random() * 2000; // * 60 + 10000;
        property int duration: Math.random() * 400 + 200;


        PropertyAnimation { duration: shine.delay; }

        ParallelAnimation {
            SequentialAnimation {
                NumberAnimation {
                         target: star
                         properties: "opacity"
                         from: 0
                         to: 0.8
                         duration: shine.duration
                         easing {type: Easing.InOutBounce}
                }
                NumberAnimation {
                         target: star
                         properties: "opacity"
                         from: 0.8
                         to: 0
                         duration: shine.duration
                         easing {type: Easing.InOutBounce}
                }
            }
            NumberAnimation {
                     target: star
                     properties: "scale"
                     from: 0
                     to: 0.6
                     duration: 2 * shine.duration
                     easing {type: Easing.InOutBounce}
            }
        }

        onStopped: {
            shine.delay = Math.random() * 2000;
            shine.duration = Math.random() * 400 + 200;
            shine.start();
        }
    }


    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
                mouseEntered(spriteID);
        }

        onExited: {
                mouseExited(spriteID);
        }

        onClicked: {
                mouseClicked(spriteID);
        }
    }

}
