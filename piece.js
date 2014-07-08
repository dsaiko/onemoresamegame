Qt.include("global.js")

var sprites = [];
var rotation = Math.floor(Math.random() * 8);
var color =  Math.floor(Math.random() * 4);

function create() {
    for(var i=0; i<8; i++) {
        var image = Qt.createQmlObject('import QtQuick 2.0; Image {anchors.fill: piece; visible: false; smooth: true}', piece);
        image.source = spritePath + color + "_" + i + ".png";
        sprites.push(image);
    }

    rotateSprite();
    shine.start()
}

function rotateSprite() {
    rotation ++;

    var r = rotation % 8;

    sprites[r].visible = true;

    for(var i=0; i< sprites.length; i++) {
        if(i !== r) sprites[i].visible = false;
    }
}

function onSelectionChange() {
    if(isSelected) {
        animation.start();
    } else {
        animation.stop();
    }
}
