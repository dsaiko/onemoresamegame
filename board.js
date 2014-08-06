.import QtQuick.LocalStorage 2.0 as Sql
.import QtQuick 2.0 as Quick

Qt.include("global.js")
Qt.include("db.js")

var sprites = [];
var globalSelectionID = 1;
var offsetY = 0;


function menuDisplay() {
    menuPanel.yAnimationEnabled = false
    if(!menuPanel.visible || menuPanel.y < -10 ) {
        menuPanel.requestHiding = false;
        menuPanel.y = - menuPanel.height;
        menuPanel.yAnimationEnabled = true
        menuPanel.visible = true;
        menuPanel.getNewImage();
        menuPanel.y = 0;
    } else {
        menuPanel.requestHiding = true;
        menuPanel.yAnimationEnabled = true
        menuPanel.visible = true;
        menuPanel.y = - menuPanel.height;
    }
}


function startGame(x, y) {
    menuPanel.type = 0;
    menuDisplay(false)
    level = 1;
    nx = x;
    ny = y;
    create();
    resetScore();
    PlatformDetails.saveValue('defultSize', x+'x'+y);
}


function init() {
    level = 1;

    var defaultSize = PlatformDetails.loadValue('defultSize', "10x15");
    playerName = PlatformDetails.loadValue('playerName', "?");
    if(!playerName) playerName="?";
    menuPanel.playerName = playerName;

    if(defaultSize === "20x15") {
        nx = 20;
        ny = 15;
    } else if(defaultSize === "20x30") {
        nx = 20;
        ny = 30;
    } else if(defaultSize === "40x30") {
        nx = 40;
        ny = 30;
    } else {
        nx = 10;
        ny = 15;
    }
}

function create() {

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

    var numberOfColors = Math.min(level + 1, 5);

    for(var y = 0; y < ny; y++) {
        var row = []
        for(var x = 0; x< nx; x++ ) {

            var rnd = Math.floor(Math.random() * numberOfColors);


            var sprite = component.createObject(board);


            sprite.color = colors[rnd];
            sprite.shape = shapes[rnd];
            sprite.source =  spritePath+"piece_color_"+colors[rnd]+"_shape_"+shapes[rnd]+".png";
            sprite.opacity=0.8

            sprite.pieceIndex = y * nx + x;
            sprite.mouseClicked.connect(mouseClicked)
            sprite.mouseEntered.connect(mouseEntered)
            sprite.mouseExited.connect(mouseExited)
            sprite.pieceDestroyed.connect(pieceDestroyed)
            sprites.push(sprite)
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

        scoreChanged(count, Math.min(level + 1, 5));
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
            saveScore(playerName, nx, ny, level, mainWindow.totalScore);
            nextLevel();
        } else if(checkGameOver()) {
            //console.log("BAD - GAME END");
            saveScore(playerName, nx, ny, level, mainWindow.totalScore);
            endOfGame();
        }
    }
}

function endOfGame() {
    if(level > 1) {
        menuPanel.type = 1;
    } else {
        menuPanel.type = -1;
    }
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


function onNextLevel() {
    level ++;
    nextLevelAnimation.start()
}

function changePlayerName(newName) {
   board.playerName = newName;
   PlatformDetails.saveValue('playerName', playerName);
}
