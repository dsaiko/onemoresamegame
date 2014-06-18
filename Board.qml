import QtQuick 2.2

import "global.js" as Global

Item {
    id: board

    //mouse entered one piece
    signal mouseEntered(int spriteID)

    //mouse exited one piece
    signal mouseExited(int spriteID)

    //piece clicked
    signal mouseClicked(int spriteID)

    signal scoreChanged(int count)

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


    function getSpriteIndex(spriteID) {
        for(var i=0; i<sprites.length; i++) {
            if(sprites[i].spriteID === spriteID) {
                return i;
            }
        }
        return -1;
    }

    onMouseEntered: {
        var index = getSpriteIndex(spriteID);
        var x = index % nx;
        var y = Math.floor(index / nx);

        var count = selectSprites(x, y, sprites[index].color, false);

        if(count > 1) {
            selectSprites(x, y, sprites[index].color, true);
        }
    }

    onMouseExited: {
        var index = getSpriteIndex(spriteID);

        var x = index % nx;
        var y = Math.floor(index / nx);

        selectSprites(x, y, sprites[index].color, false);
    }


    onMouseClicked: {
        var index = getSpriteIndex(spriteID);

        var x = index % nx;
        var y = Math.floor(index / nx);

        var count = selectSprites(x, y, sprites[index].color, false);

        if(count > 0) {
            scoreChanged(count);
        }
    }


    function selectSprites(x, y, color, isSelected, isInitialized) {
        if(!isInitialized) {
            resetCounters();
        }

        if(x < 0 || y < 0) return 0;
        if(x >= nx || y >= ny) return 0;

        var i = y * nx + x;
        var count = 0;


        var sprite = sprites[i];
        if(sprite.color === color && ! sprite.isCounted) {
            sprite.isSelected = isSelected;
            sprite.isCounted = true;

            count ++;
            count += selectSprites(x-1, y, color, isSelected, true);
            count += selectSprites(x, y-1, color, isSelected, true);
            count += selectSprites(x+1, y, color, isSelected, true);
            count += selectSprites(x, y+1, color, isSelected, true);
        }

        return count;
    }

    function resetCounters() {
        for(var i=0; i<sprites.length; i++) {
            sprites[i].isCounted = false
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
                sprite.mouseClicked.connect(mouseClicked)
                sprites.push(sprite)
            }
        }

    }

}
