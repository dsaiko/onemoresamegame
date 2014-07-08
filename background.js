var squares = [];

function create() {
    var component = Qt.createComponent("BackgroundSprite.qml");

    for(var i=0; i < 500; i++) {
        var sprite = component.createObject(background);
        squares.push(sprite)
    }
}

function resize() {
    for(var i=0; i<squares.length; i++) {
        var sprite = squares[i];
        sprite.x = (1.5 * width * sprite.rx) - width / 4
        sprite.y = (1.5 * height * sprite.ry) - height / 4
    }

}
