Qt.include("global.js")

var rotation = 0;

function create() {
    shine.start()
}


function isShapeStar() {
    return shape === 4;
}

function isShapeSquare() {
    return shape === 1;
}

function isShapeCircle() {
    return shape === 2;
}

function isShapeTriangle() {
    return shape === 3;
}

function isShapePentagon() {
    return shape === 5;
}


function onSelectionChange() {
    if(isSelected) {
        spriteRect.visible = true;
    } else {
        spriteRect.visible = false;
    }
}


function setScale() {
    if(isShapeStar()) {
        sprite.scale = 1;
        shiningStar.x = piece.width / 8;
        shiningStar.y = piece.height / 8;
    } else
    if(isShapeSquare()) {
        sprite.scale = 0.8;
        shiningStar.x = - piece.width / 15;
        shiningStar.y = 0;
    } else
    if(isShapeCircle()) {
        sprite.scale = 0.9;
        shiningStar.x = 0;
        shiningStar.y = 0;
    } else
    if (isShapeTriangle()) {
        sprite.scale = 0.9;
        shiningStar.x = piece.width / 10;
        shiningStar.y = piece.height / 6;
    } else
    if(isShapePentagon()) {
        sprite.scale = 0.9;
    }

}
