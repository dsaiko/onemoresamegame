Qt.include("global.js")


var sprites = [];
var globalSelectionID = 1;

function create() {
    var component = Qt.createComponent("Piece.qml");

    for(var y = 0; y < ny; y++) {
        var row = []
        for(var x = 0; x< nx; x++ ) {
            var sprite = component.createObject(board);
            sprite.pieceIndex = y * nx + x;
            sprite.mouseClicked.connect(mouseClicked)
            sprite.mouseEntered.connect(mouseEntered)
            sprite.mouseExited.connect(mouseExited)
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

function onMouseExited(pieceIndex) {
    onMouseEntered(-1);
}

function onMouseEntered(pieceIndex) {
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i]) sprites[i].isSelected = false;
    }

    if(pieceIndex < 0) return;

    var x = pieceIndex % nx;
    var y = Math.floor(pieceIndex / nx);

    var count = 0;

    var selectionID = (++globalSelectionID);
    // select all other pieces. If there will be at least one
    // more sprite selected, we wil lalso select this one

    sprites[pieceIndex].selectionID = selectionID;

    count += selectSprites(x, y-1, sprites[pieceIndex].color, selectionID);
    count += selectSprites(x+1, y, sprites[pieceIndex].color, selectionID);
    count += selectSprites(x, y+1, sprites[pieceIndex].color, selectionID);
    count += selectSprites(x-1, y, sprites[pieceIndex].color, selectionID);

    if(count > 0) {
        sprites[pieceIndex].isSelected = true;
    }
}

function onMouseClicked(pieceIndex) {
    if(sprites[pieceIndex].isSelected) {
        //second click

        var count = 0;
        for(var i=0; i<sprites.length; i++) {
            if(sprites[i] && sprites[i].isSelected) {
                sprites[i].destroyPiece();
                count ++;
            }
        }

        scoreChanged(count);
    } else {
        //first click
        onMouseEntered(pieceIndex);
    }
}


function selectSprites(x, y, color, selectionID) {
    if(x < 0 || y < 0) return 0;
    if(x >= nx || y >= ny) return 0;

    var i = y * nx + x;
    var count = 0;

    var sprite = sprites[i];
    if(sprite && sprite.color === color && sprite.selectionID !== selectionID) {
        sprite.isSelected = true;
        sprite.selectionID = selectionID;

        count ++;
        count += selectSprites(x-1, y, color, selectionID);
        count += selectSprites(x, y-1, color, selectionID);
        count += selectSprites(x+1, y, color, selectionID);
        count += selectSprites(x, y+1, color, selectionID);
    }

    return count;
}

function destroyPiece(pieceIndex) {
    sprites[pieceIndex].destroy();
    sprites[pieceIndex] = null;

    var count = 0;
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i] && sprites[i].isDestroying) {
            count++;
            break;
        }
    }

    if(count == 0) {
        fallDown();
        var morePieces = fallLeft();

        if(!morePieces) {
            console.log("GOOD - GAME END");
        } else if(checkGameOver()) {
            console.log("BAD - GAME END");
        }
    }
}

function checkGameOver() {
    var c = -1;

    //check two same colors on top of each other
    for(var x = 0; x<nx; x++) {
        c = -1;
        for(var y = 0; y<ny; y++) {
            var i = y * nx + x;

            if(sprites[i]) {
                if(c === sprites[i].color) return false;
                c = sprites[i].color;
            } else {
                c = -1;
            }

        }

    }

    //check two same colors side by side
    for(var y = 0; y<ny; y++) {
        c = -1;
        for(var x = 0; x<nx; x++) {
            var i = y * nx + x;

            if(sprites[i]) {
                if(c === sprites[i].color) return false;
                c = sprites[i].color;
            } else {
                c = -1;
            }

        }

    }

    return true;
}

function fallDown() {
    for(var x = 0; x < nx; x++) {
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
                    sprites[i] = null;
                    sprites[tempI] = sprite;
                    sprites[tempI].pieceIndex = tempI;
                    sprite.y = tempY * cy;
                }
            }
        }
    }
}

// returns false if there are no more pieces on the board
function fallLeft() {
    for(var x = 0; x < nx - 1; x++) {
        var count = 0;

        for(var y = ny - 1; y >= 0; y--) {
            var i = y*nx + x;
            if(sprites[i]) {
                count ++;
                break;
            }
        }

        if(count == 0) {
            doubleScore();

            var anyFound = false;

            for(var ix = x + 1; ix < nx; ix++) {
                for(var y = 0; y < ny; y++) {
                    var i = y*nx + ix;

                    var sprite = sprites[i];
                    if(sprite) {
                        anyFound = true;
                        sprite.xAnimationEnabled = true;
                        sprites[i] = null;
                        sprites[i-1] = sprite;
                        sprites[i-1].pieceIndex = i - 1;
                        sprite.x = (ix -1) * cx;
                    }
                }
            }

            //make sure we process the same row if again to check if it is still empty
            if(anyFound) {
                x--;
            } else if(x == 0) {
                return false;
            }
        }
    }

    return true;
}
