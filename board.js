Qt.include("global.js")


var sprites = [];
var globalSelectionID = 1;
var offsetY = 0;


function menuDisplay() {
    endOfGamePanel.getNewImage();
    endOfGamePanel.visible = true;
    endOfGamePanel.y = 0;
    setMenuButtonType(1)
}

function menuHide() {
    endOfGamePanel.visible = true;
    endOfGamePanel.y = - endOfGamePanel.height;
    setMenuButtonType(2)
}

function startGameEasy() {
    var resize = false;

    endOfGamePanel.type = 0;
    menuHide()
    numberOfColors = 2;
    if(nx != 10 || ny != 15) {
        nx = 10;
        ny = 15;
        resize = true;
    }
    create(resize);
    PlatformDetails.saveValue('defultSize', 10);
}

function startGameMedium() {
    var resize = false;
    endOfGamePanel.type = 0;
    menuHide()
    numberOfColors = 2;
    if(nx != 20 || ny != 15) {
        resize = true;
        nx = 20;
        ny = 15;
    }
    create(resize);
    PlatformDetails.saveValue('defultSize', 20);
}

function startGameHard() {
    var resize = false;
    endOfGamePanel.type = 0;
    menuHide()
    numberOfColors = 2;
    if(nx != 20 || ny != 30) {
        resize = true;
        nx = 20;
        ny = 30;
        newGameStarted();
    }
    create(resize);
    PlatformDetails.saveValue('defultSize', 30);
}

function init() {
    numberOfColors = 2;
    var defaultSize = PlatformDetails.loadValue('defultSize', 10);
    if(defaultSize === "20") {
        nx = 20;
        ny = 15;
    } else
    if(defaultSize === "30") {
            nx = 20;
            ny = 30;
    } else {
        nx = 10;
        ny = 15;
    }


}

function create(forceResize) {

    //destroy all pieces first
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i]) sprites[i].destroy();
        sprites[i]=null;
    }
    sprites = [];

    var colors = [1,2,3,4,5];
    var shapes = [1,2,3,4,5];

    shuffle(colors);
    shuffle(shapes);

    var component = Qt.createComponent("Piece.qml");

    for(var y = 0; y < ny; y++) {
        var row = []
        for(var x = 0; x< nx; x++ ) {

            var rnd = Math.floor(Math.random() * numberOfColors);


            var sprite = component.createObject(board);


            sprite.color = colors[rnd];
            sprite.shape = shapes[rnd];
            sprite.source =  spritePath+"piece_color_"+colors[rnd]+"_shape_"+shapes[rnd]+".png";

            sprite.pieceIndex = y * nx + x;
            sprite.mouseClicked.connect(mouseClicked)
            sprite.mouseEntered.connect(mouseEntered)
            sprite.mouseExited.connect(mouseExited)
            sprite.pieceDestroyed.connect(pieceDestroyed)
            sprites.push(sprite)
        }
    }

    setMenuButtonType(2); //menu hidden
    resetScore();
    if(forceResize) {
        resize();
        newGameStarted();
    } else {
        resize();
    }

}

function resize() {
    cx = Math.min(board.width / nx, board.height / ny) ;
    cy = cx;

    //force bottom alignment of the board
    offsetY = board.height - ny * cy;

    for(var y = 0; y < ny; y++) {
        for(var x = 0; x< nx; x++ ) {
            var sprite =  sprites[y * nx + x];
            if(sprite) {
                sprite.x = x * cx;
                sprite.y = offsetY + y * cy;
                sprite.width = cx;
                sprite.height = cy;
            }
        }
    }
    resized();

}

function onMouseExited(pieceIndex) {
    onMouseEntered(-1);
}

function onMouseEntered(pieceIndex) {
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i]) sprites[i].isSelected = false;
    }

    if(PlatformDetails.isMobile == false && PlatformDetails.isMouseButtonPressed) {
        // this is a fix to behaviour when pieces move and mouse stays on the same place and user clicks
        return;
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

        scoreChanged(count, numberOfColors);
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
        if(sprites[i]) {
            sprites[i].isSelected = false;
            if(sprites[i].isDestroying) {
                count++;
                break;
            }
        }
    }

    if(count == 0) {
        fallDown();
        var morePieces = fallLeft();

        if(!morePieces) {
            //console.log("GOOD - GAME END");
            numberOfColors ++;
        } else if(checkGameOver()) {
            //console.log("BAD - GAME END");
            endOfGame();
        }
    }
}

function endOfGame() {
    endOfGamePanel.type = -1;
    menuDisplay();
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
                    sprite.y = offsetY + tempY * cy;
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
