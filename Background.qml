import QtQuick 2.2

Item {
    id: background

    anchors.fill: parent

    property var squares: []


    function resize() {
        for(var i=0; i<squares.length; i++) {
            var sprite = squares[i];
            sprite.x = (1.5 * width * sprite.rx) - width / 4
            sprite.y = (1.5 * height * sprite.ry) - height / 4
        }

    }

    onWidthChanged: {
        resize();
    }

    onHeightChanged:  {
        resize();
    }

    Component {
        id: spriteFactory
        BackgroundSprite {

        }
    }

    Component.onCompleted: {
        for(var i=0; i < 300; i++) {
            var sprite = spriteFactory.createObject(background);
            squares.push(sprite)
        }
    }
}
