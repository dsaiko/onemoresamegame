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
    signal doubleScore

    signal pieceDestroyed(int spriteID)

    property var sprites: []

    property int nx: 10
    property int ny: 15


    property int cx: board.width / nx;
    property int cy: board.height / ny;

    function resize() {

        cx = board.width / nx;
        cy = board.height / ny;

        for(var y = 0; y < ny; y++) {
            for(var x = 0; x< nx; x++ ) {
                var sprite =  sprites[y * nx + x];
                if(sprite) {
                    sprite.x = x * cx;
                    sprite.y = y * cy;
                    sprite.width = cx;
                    sprite.height = cy;
                }
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
            if(sprites[i] && sprites[i].spriteID === spriteID) {
                return i;
            }
        }
        return -1;
    }

    onMouseEntered: {
        var index = getSpriteIndex(spriteID);
        if(sprites[index]) {
            var x = index % nx;
            var y = Math.floor(index / nx);

            var count = selectSprites(x, y, sprites[index].color, false);

            if(count > 1) {
                selectSprites(x, y, sprites[index].color, true);
            }
        }
    }

    onMouseExited: {
        var index = getSpriteIndex(spriteID);
        if(sprites[index]) {
            var x = index % nx;
            var y = Math.floor(index / nx);

            selectSprites(x, y, sprites[index].color, false);
        }
    }


    onPieceDestroyed: {
        var index = getSpriteIndex(spriteID);
        if(sprites[index]) {
            sprites[index].destroy();
            sprites[index] = null;


            var count = 0;
            for(var i=0; i<sprites.length; i++) {
                if(sprites[i] && sprites[i].isD) {
                    count ++;
                }
            }

            if(count == 0) {
                fallDown()
                fallLeft()
            }
        }


    }

    onMouseClicked: {
        var index = getSpriteIndex(spriteID);
        if(sprites[index]) {

            var x = index % nx;
            var y = Math.floor(index / nx);

            var count = selectSprites(x, y, sprites[index].color, false);

            if(count > 1) {
                for(var i=0; i<sprites.length; i++) {
                    if(sprites[i] && sprites[i].isCounted) {
                        sprites[i].isSelected = true
                        sprites[i].destroyPiece();
                    }
                }

                scoreChanged(count);
            }
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
        if(sprite && sprite.color === color && ! sprite.isCounted) {
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
            if(sprites[i]) sprites[i].isCounted = false
        }
    }


    function fallDown() {
        for(var x = nx -1; x >= 0; x--) {
            for(var y = ny - 2; y >=0; y --) {
                var i = y*nx + x;
                if(sprites[i]) {

                    var tempY = y;
                    var tempI = i;

                    while(tempY < ny - 1) {
                        if(sprites[tempI + nx]) break;
                        tempI += nx;
                        tempY ++;
                    }

                    //can we fall down?
                    if(tempY != y) {
                        var sprite = sprites[i];
                        sprite.y = tempY * cy;
                        sprites[i] = null;
                        sprites[tempI] = sprite;
                    }
                }
            }
        }
    }

    function fallLeft() {
        for(var x = 0; x < nx; x++) {
            var count = 0;

            for(var y = 0; y < ny; y++) {
                var i = y*nx + x;
                if(sprites[i]) {
                    count ++;
                    break;
                }
            }

            if(count == 0) {
                doubleScore();
                for(var ix = x + 1; ix < nx; ix++) {
                    for(var y = 0; y < ny; y++) {
                        var i = y*nx + ix;

                        var sprite = sprites[i];
                        if(sprite) {
                            sprite.spawned = true;
                            sprite.x = (ix -1) * cx;
                            sprites[i] = null;
                            sprites[i-1] = sprite;
                            sprite.spawned = false;
                        }
                    }
                }
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
                sprite.mouseClicked.connect(mouseClicked)
                sprite.pieceDestroyed.connect(pieceDestroyed)
                sprites.push(sprite)
            }
        }

    }

}
