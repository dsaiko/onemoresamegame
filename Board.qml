import QtQuick 2.2

import "global.js" as Global

Item {
    id: board

    signal mouseEntered(int spriteID)
    signal mouseExited(int spriteID)

    property var sprites: []

    property int nx: 10
    property int ny: 15


    function resize() {

        var cx = board.width / nx;
        var cy = board.height / ny;

        for(var y = 0; y < ny; y++) {
            for(var x = 0; x< nx; x++ ) {
                var sprite =  sprites[y * nx + x];

                sprite.x = x * cx;
                sprite.y = y * cy;
                sprite.width = cx;
                sprite.height = cy;
            }
        }

    }

    onWidthChanged: {
        resize();
    }

    onHeightChanged:  {
        resize();
    }


    onMouseEntered: {
        var index = -1;
        for(var i=0; i<sprites.length; i++) {
            if(sprites[i].spriteID === spriteID) {
                index = i;
            }
        }


        var x = index % nx;
        var y = Math.floor(index / nx);
        fillAnimation(x, y, sprites[index].color, true);
    }

    onMouseExited: {
        var index = -1;
        for(var i=0; i<sprites.length; i++) {
            if(sprites[i].spriteID === spriteID) {
                index = i;
            }
        }


        var x = index % nx;
        var y = Math.floor(index / nx);
        fillAnimation(x, y, sprites[index].color, false);
    }


    function fillAnimation(x, y, color, isSelected) {
        if(x < 0 || y < 0) return;
        if(x >= nx || y >= ny) return;

        var i = y * nx + x;

        var sprite = sprites[i];
        if(sprite.color === color) {
            if(sprite.isSelected !== isSelected) {
                sprite.isSelected = isSelected;

                fillAnimation(x-1, y, color, isSelected);
                fillAnimation(x, y-1, color, isSelected);
                fillAnimation(x+1, y, color, isSelected);
                fillAnimation(x, y+1, color, isSelected);
            }
        }

    }


    Component {
        id: pieceFactory
        Piece {

        }
    }

    Component.onCompleted: {
        for(var y = 0; y < ny; y++) {
            var row = []
            for(var x = 0; x< nx; x++ ) {
                var sprite = pieceFactory.createObject(this);
                sprite.spriteID = y * nx + x;
                sprite.mouseEntered.connect(mouseEntered)
                sprite.mouseExited.connect(mouseExited)
                sprites.push(sprite)
            }
        }

    }

}
