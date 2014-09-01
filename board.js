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

// code signoff date: 2014-08-24

var sprites = [];
var globalSelectionID = 1;
var offsetY = 0;
var colorStats = []
var selectedSprites = []
var currentBoardSize = '*'

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


function startGame(x, y, boardSize) {
    menuPanel.type = 0;
    if(menuPanel.visible)
        menuDisplay(false)
    level = 1;
    boardGridWidth = x;
    boardGridHeight = y;
    create();
    resetScore();
    currentBoardSize = boardSize;
    PlatformDetails.saveValue('defaultSize', boardSize);
}


function init() {
    level = 1;

    var defaultSize = PlatformDetails.loadValue('defaultSize', "*");
    playerName = PlatformDetails.loadValue('playerName', "?");
    roomNumber = PlatformDetails.loadValue('roomNumber', "?");

    if(!playerName) playerName="?";
    menuPanel.playerName = playerName;

    if(!validateRoomNumber(roomNumber)) {
        roomNumber = generateRoomNumber();
        PlatformDetails.saveValue('roomNumber', roomNumber);
    }

    if(defaultSize === "**") {
        menuPanel.startGame2()
    } else if(defaultSize === "***") {
        menuPanel.startGame3()
    } else if(defaultSize === "**") {
        menuPanel.startGame4()
    } else {
        menuPanel.startGame1()
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

    var grid = []

    while(true) {
        var isOK = true;

        grid = designBoard(numberOfColors, level)
        colorStats = [0, 0, 0, 0, 0]
        for(i=0; i< boardGridHeight * boardGridWidth; i++) {
            var rnd = grid[i]
            var color = colors[rnd]
            colorStats[color -1]++;
        }

        //bugfix: do not allow designing board with only one piece of a color
        for(i=0; i<colorStats.length; i++) {
            if(colorStats[i] > 0 && colorStats[i] < 2) {
                isOK = false;
                break;
            }
        }

        if(isOK)
            break;
    }

    for(i=0; i< boardGridHeight * boardGridWidth; i++) {
            var rnd = grid[i]
            var color = colors[rnd]
            var shape = shapes[rnd];

            var sprite = component.createObject(board, {
                "color": color,
                "shape": shape,
            });

            sprite.index = i;
            sprite.mouseClicked.connect(mouseClicked)
            sprite.mouseEntered.connect(mouseEntered)
            sprite.mouseExited.connect(mouseExited)
            sprite.reComputeAspectRatio()
            sprites.push(sprite)
    }
}

function onMouseExited(index) {
    onMouseEntered(-1);
}

function onMouseEntered(index) {
    for(var i=0; i<selectedSprites.length; i++) {
        if(selectedSprites[i]) selectedSprites[i].isSelected = false;
    }
    selectedSprites = []

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
        selectedSprites.push(sprite)
    }
}

function onMouseClicked(index) {

    var sprite = sprites[index];
    if(!sprite) return;
    if(sprite.destroying) return;

    if(sprite.isSelected) {
        //second click

        var count = selectedSprites.length;
        for(var i=0; i < count; i++) {
            sprite = selectedSprites[i];
            colorStats[sprite.color - 1] --;
            sprites[sprite.index] = null;
            sprite.destroyPiece();
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
        fallLeft();

        var preliminaryEnd = false;
        var totalCount = 0;

        for(var i=0; i< colorStats.length; i++) {
            totalCount += colorStats[i]
            if(colorStats[i] === 1) preliminaryEnd = true
        }

        if(totalCount == 0) {
            //console.log("GOOD - GAME END");
            saveScore(playerName, boardGridWidth, boardGridHeight, level, mainWindow.totalScore, currentBoardSize);
            nextLevel();
        } else if(preliminaryEnd || checkGameOver()) {
            //console.log("BAD - GAME END");
            saveScore(playerName, boardGridWidth, boardGridHeight, level, mainWindow.totalScore, currentBoardSize);
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
        selectedSprites.push(sprite)
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
    if(level > 2) {
        menuPanel.type = 1;
    } else {
        menuPanel.type = -1;
    }
    menuDisplay();
    for(var i=0; i < sprites.length; i++) {
        var sprite = sprites[i];
        if(sprite) {
            sprite.mouseEnabled = false;
        }
    }
}

function getSpriteColor(x, y) {
    if(x < 0 || x >= boardGridWidth) return -1;
    if(y < 0 || y >= boardGridHeight) return -1;

    var i = y * boardGridWidth + x;
    var sprite = sprites[i]
    if(sprite)
          return sprite.color;
    return -1;
}

function checkGameOver() {
     //check two same colors on top of each other or side by side
    for(var x = 0; x<boardGridWidth; x++) {
        for(var y = boardGridHeight - 1; y >= 0; y--) {
            var c = getSpriteColor(x, y)
            if(c !== -1) {
                var c1 = getSpriteColor(x + 1, y)
                if(c === c1) return false;

                var c2 = getSpriteColor(x, y - 1)
                if(c === c2) return false;
            }
        }
    }

    return true;
}

function fallDown() {
    for (var x = 0; x < boardGridWidth; x ++) {
        var emptyCount = 0;
        for (var y = boardGridHeight - 1; y >= 0; y --) {
            var i = y * boardGridWidth + x;
            var sprite = sprites[i];

            if(sprite) {
                if(emptyCount > 0) {
                    sprite.index = (y + emptyCount) * boardGridWidth + x
                    sprites[i] = null;
                    sprites[sprite.index] = sprite;
                }

            } else {
                emptyCount ++;
            }
        }
    }
}

function fallLeft() {
    var emptyCount = 0;
    for (var x = 0; x < boardGridWidth; x++) {
        var maxY = (boardGridHeight - 1) * boardGridWidth + x;
        if(sprites[maxY]) {
            if(emptyCount > 0) {
                for(var y = 0; y < boardGridHeight; y ++) {
                    var i = y * boardGridWidth + x;
                    var sprite = sprites[i];
                    if(sprite) {
                        sprite.xAnimationEnabled = true;
                        sprite.index = y * boardGridWidth + x - emptyCount
                        sprites[i] = null;
                        sprites[sprite.index] = sprite;
                    }
                }
            }
        } else {
            emptyCount ++;
        }
    }
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


function getLevelConfig(arr, level) {
    if(level < arr.length) return arr[level];
    return arr[arr.length - 1];
}

//returns grid with colors for pieces
//makes the board design less random and lower levels more easy
function designBoard(numberOfColors, level) {
    var grid = [];


    var arrayMaxRandomBase =  [ 1,  2,  2,  2,  3, 3, 3, 3, 4, 5] //random base per level
    var arrayBlobSize =       [ 4,  4,  4,  3,  3, 3, 3, 2, 2, 2] //blob size per level
    var arrayBlobRandomness = [20, 20, 15, 15, 10, 5, 4, 3, 2, 2] // reverse blob randomnes

    var maxRadomBase = getLevelConfig(arrayMaxRandomBase, level - 1)
    for(var y = 0; y < boardGridHeight; y++) {
        for(var x = 0; x< boardGridWidth; x++ ) {
            var rnd = Math.floor(Math.random() * maxRadomBase)
            grid.push(rnd)
        }
    }

    //after lv 10 - the base is fully random
    if(level < 10) {
        var blobSize = getLevelConfig(arrayBlobSize, level - 1)
        var blobCount = Math.max(boardGridHeight, boardGridWidth)
        var blobRandomness = getLevelConfig(arrayBlobRandomness, level - 1)
        for(var blobIndex = 0; blobIndex < blobCount; blobIndex ++) {
            //create blob
            var color = Math.floor(Math.random() * numberOfColors)
            var blob = []
            for(var blobY = 0; blobY < blobSize; blobY++) {
                for(var blobX = 0; blobX < blobSize; blobX++) {
                    if(Math.floor(Math.random() * blobRandomness) != 0) {
                        blob.push(color);
                    } else {
                        blob.push(-1);
                    }
                }
            }

            //put a blob inside a grid to random position
            var blobStartX = Math.floor(Math.random() * (boardGridWidth - blobSize))
            var blobStartY = Math.floor(Math.random() * (boardGridHeight - blobSize))
            for(blobY = 0; blobY < blobSize; blobY++) {
                for(blobX = 0; blobX < blobSize; blobX++) {
                    var c = blob[blobY * blobSize + blobX];
                    if(c >= 0)
                        grid[(blobY + blobStartY) * boardGridWidth + (blobX + blobStartX)] = c
                }
            }
        }
    }
    return grid;
}
