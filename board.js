/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
.import QtQuick.LocalStorage 2.0 as Sql
.import QtQuick 2.0 as Quick

Qt.include("global.js")
Qt.include("db.js")

// code signoff date: 2014-08-16

var sprites = [];
var globalSelectionID = 1;
var offsetY = 0;


function menuDisplay() {
    menuPanel.yAnimationEnabled = false
    if(!menuPanel.visible || menuPanel.y < -10 ) {
        startShineAnimation(false);
        menuPanel.requestHiding = false;
        menuPanel.y = - menuPanel.height;
        menuPanel.yAnimationEnabled = true
        menuPanel.visible = true;
        menuPanel.getNewImage();
        menuPanel.y = 0;
    } else {
        startShineAnimation(true);
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
    boardGridWidth = x;
    boardGridHeight = y;
    create();
    resetScore();
    PlatformDetails.saveValue('defaultSize', x+'x'+y);
}


function init() {
    level = 1;

    var defaultSize = PlatformDetails.loadValue('defaultSize', "10x15");
    playerName = PlatformDetails.loadValue('playerName', "?");
    roomNumber = PlatformDetails.loadValue('roomNumber', "?");

    if(!playerName) playerName="?";
    menuPanel.playerName = playerName;

    if(!validateRoomNumber(roomNumber)) {
        roomNumber = generateRoomNumber();
        PlatformDetails.saveValue('roomNumber', roomNumber);
    }

    if(defaultSize === "20x15") {
        boardGridWidth = 20;
        boardGridHeight = 15;
    } else if(defaultSize === "20x30") {
        boardGridWidth = 20;
        boardGridHeight = 30;
    } else if(defaultSize === "40x30") {
        boardGridWidth = 40;
        boardGridHeight = 30;
    } else {
        boardGridWidth = 10;
        boardGridHeight = 15;
    }

    dbInit();
    create();
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

    for(var y = 0; y < boardGridHeight; y++) {
        var row = []
        for(var x = 0; x< boardGridWidth; x++ ) {

            var rnd = Math.floor(Math.random() * numberOfColors);


            var sprite = component.createObject(board);


            sprite.color = colors[rnd];
            sprite.shape = shapes[rnd];
            sprite.source =  spritePath+"piece_color_"+colors[rnd]+"_shape_"+shapes[rnd]+".png";
            sprite.opacity=0.8

            sprite.index = y * boardGridWidth + x;
            sprite.mouseClicked.connect(mouseClicked)
            sprite.mouseEntered.connect(mouseEntered)
            sprite.mouseExited.connect(mouseExited)
            sprites.push(sprite)
        }
    }
}

function onMouseExited(index) {
    onMouseEntered(-1);
}

function onMouseEntered(index) {
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i]) sprites[i].isSelected = false;
    }

    if(PlatformDetails.isMobile == false && PlatformDetails.isMouseButtonPressed) {
        // this is a fix to behaviour when pieces move and mouse stays on the same place and user clicks
        return;
    }


    if(index < 0) return;
    var sprite = sprites[index];
    if(!sprite) return;


    var x = index % boardGridWidth;
    var y = Math.floor(index / boardGridWidth);

    var count = 0;

    var selectionID = (++globalSelectionID);
    // select all other pieces. If there will be at least one
    // more sprite selected, we wil lalso select this one

    sprite.selectionID = selectionID;

    count += selectSprites(x, y-1, sprite.color, selectionID);
    count += selectSprites(x+1, y, sprite.color, selectionID);
    count += selectSprites(x, y+1, sprite.color, selectionID);
    count += selectSprites(x-1, y, sprite.color, selectionID);

    if(count > 0) {
        sprite.isSelected = true;
    }
}

function onMouseClicked(index) {
    var sprite = sprites[index];
    if(!sprite) return;
    if(sprite.destroying) return;

    if(sprite.isSelected) {
        //second click

        var count = 0;
        for(var i=0; i<sprites.length; i++) {
            if(sprites[i] && sprites[i].isSelected) {
                sprites[i].destroyPiece();
                sprites[i] = null;
                count ++;
            }
        }

        if(count > 0) board.fallTimer.restart()
        scoreChanged(count, Math.min(level + 1, 5));
    } else {
        //first click
        onMouseEntered(index);
    }
}

function fallPieces() {
        fallDown();
        var morePieces = fallLeft();

        if(!morePieces) {
            //console.log("GOOD - GAME END");
            saveScore(playerName, boardGridWidth, boardGridHeight, level, mainWindow.totalScore);
            nextLevel();
        } else if(checkGameOver()) {
            //console.log("BAD - GAME END");
            saveScore(playerName, boardGridWidth, boardGridHeight, level, mainWindow.totalScore);
            endOfGame();
        }
}

function selectSprites(x, y, color, selectionID) {
    if(x < 0 || y < 0) return 0;
    if(x >= boardGridWidth || y >= boardGridHeight) return 0;

    var i = y * boardGridWidth + x;
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
    for(var x = 0; x<boardGridWidth; x++) {
        c = -1;
        for(var y = 0; y<boardGridHeight; y++) {
            var i = y * boardGridWidth + x;

            if(sprites[i]) {
                if(c === sprites[i].color) return false;
                c = sprites[i].color;
            } else {
                c = -1;
            }

        }

    }

    //check two same colors side by side
    for(var y = 0; y<boardGridHeight; y++) {
        c = -1;
        for(var x = 0; x<boardGridWidth; x++) {
            var i = y * boardGridWidth + x;

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
    for(var x = 0; x < boardGridWidth; x++) {
        for(var y = boardGridHeight - 2; y >=0; y --) {
            var i = y*boardGridWidth + x;
            if(sprites[i]) {

                var tempY = y;
                var tempI = i;

                while(tempY < boardGridHeight - 1) {
                    if(sprites[tempI + boardGridWidth]) break;
                    tempI += boardGridWidth;
                    tempY ++;
                }

                //can we fall down?
                if(tempY != y) {
                    var sprite = sprites[i];
                    sprites[i] = null;
                    sprites[tempI] = sprite;
                    sprites[tempI].index = tempI;
                }
            }
        }
    }
}

// returns false if there are no more pieces on the board
function fallLeft() {
    for(var x = 0; x < boardGridWidth - 1; x++) {
        var count = 0;

        for(var y = boardGridHeight - 1; y >= 0; y--) {
            var i = y*boardGridWidth + x;
            if(sprites[i]) {
                count ++;
                break;
            }
        }

        if(count == 0) {
            var anyFound = false;

            for(var ix = x + 1; ix < boardGridWidth; ix++) {
                for(var y = 0; y < boardGridHeight; y++) {
                    var i = y*boardGridWidth + ix;

                    var sprite = sprites[i];
                    if(sprite) {
                        anyFound = true;
                        sprite.xAnimationEnabled = true;
                        sprites[i] = null;
                        sprites[i-1] = sprite;
                        sprites[i-1].index = i - 1;
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


function changeRoomNumber() {
    if(validateRoomNumber(roomNumber)) {
        PlatformDetails.saveValue('roomNumber', roomNumber);
        reloadScore();
        return true;
    }

    return false;
}

function startShineAnimation(enabled) {
    for(var i=0; i<sprites.length; i++) {
        if(sprites[i]) {
            if(enabled) {
                sprites[i].shineAnimation.resume();
            } else {
                sprites[i].shineAnimation.pause();
            }
        }
    }
}
