Qt.include("global.js")


var sprites = [];

function create() {
    var component = Qt.createComponent("Piece.qml");

    for(var y = 0; y < ny; y++) {
        var row = []
        for(var x = 0; x< nx; x++ ) {
            var sprite = component.createObject(board);
            sprite.pieceIndex = y * nx + x;
            sprite.mouseClicked.connect(mouseClicked)
            sprite.mouseEntered.connect(mouseEntered)
            sprite.pieceDestroyed.connect(pieceDestroyed)
            sprites.push(sprite)
        }
    }
}

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

function onMouseEntered(pieceIndex) {
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i]) sprites[i].isSelected = false;
    }

    if(sprites[pieceIndex]) {
        var x = pieceIndex % nx;
        var y = Math.floor(pieceIndex / nx);

        var count = selectSprites(x, y, sprites[pieceIndex].color, false);

        if(count > 1) {
            selectSprites(x, y, sprites[pieceIndex].color, true);
        }
    }
}

function onMouseClicked(pieceIndex) {
    if(sprites[pieceIndex]) {

        if(sprites[pieceIndex].isSelected) {
            //second click

            var x = pieceIndex % nx;
            var y = Math.floor(pieceIndex / nx);

            var count = selectSprites(x, y, sprites[pieceIndex].color, false);

            if(count > 1) {
                for(var i=0; i<sprites.length; i++) {
                    if(sprites[i] && sprites[i].isCounted) {
                        sprites[i].isSelected = true
                        sprites[i].destroyPiece();
                    }
                }

                scoreChanged(count);
            }
        } else {
            //first click
            onMouseEntered(pieceIndex);
        }
    }
}

function resetCounters() {
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i]) sprites[i].isCounted = false
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

function destroyPiece(pieceIndex) {
    if(sprites[pieceIndex]) {
        sprites[pieceIndex].destroy();
        sprites[pieceIndex] = null;

        var count = 0;
        for(var i=0; i<sprites.length; i++) {
            if(sprites[i] && sprites[i].isDestroying) {
                count ++;
            }
        }

        if(count == 0) {
            fallDown()
            fallLeft()
        }
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
                    sprites[tempI].pieceIndex = tempI;
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
                        sprites[i-1].pieceIndex = i - 1;
                        sprite.spawned = false;
                    }
                }
            }
        }
    }
}
