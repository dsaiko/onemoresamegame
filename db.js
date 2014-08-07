var db = null;


function dbInit() {
    if(db) return;

    db = Sql.LocalStorage.openDatabaseSync("OneMoreSameGame", "2.0", "OneMoreSameGame High Scores", 100);

    db.transaction(function(tx) {
        tx.executeSql(
           'CREATE TABLE IF NOT EXISTS \
            topscores(\
                name TEXT, \
                roomNumber TEXT, \
                boardSize TEXT, \
                level NUMBER, \
                score NUMBER, \
                created TEXT\
            )');
    });
}

function saveScore(playerName, nx, ny, level, totalScore) {
    dbInit();

    var boardSize = nx + "x" + ny;

    var dataStr = "INSERT INTO topscores VALUES(?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
    var data = [playerName, roomNumber, boardSize, level, totalScore];

    db.transaction(function(tx) {
        tx.executeSql(dataStr, data);

        //clean up the scores
        tx.executeSql(
            'delete from topscores where roomNumber!=?',
            [roomNumber]
        );

        tx.executeSql(
            'delete \
             from \
                topscores \
             where \
                boardSize=? \
                and roomNumber=? \
                and rowid not in ( \
                    select rowid from topscores \
                    where \
                    boardSize=? \
                    and roomNumber=?  \
                    order by score desc \
                    limit 5 \
                )',
            [boardSize, roomNumber, boardSize, roomNumber]
        );

    });

    reloadScore();
}



function reloadScore() {
    dbInit()
    scoreModel.clear();

    db.transaction(function(tx) {

        var boardSizes = tx.executeSql('select distinct boardSize from topscores where roomNumber=? order by boardSize', [roomNumber]);
        var limit = 3

        for(var n=0; n < boardSizes.rows.length; n++) {
            var boardSize = boardSizes.rows.item(n).boardSize;

            var rs = tx.executeSql(
                        'select * from topscores where boardSize=? and roomNumber=? order by score desc limit ?',
                        [boardSize, roomNumber, limit]
            );


            var i = 0;
            for(; i < rs.rows.length; i++) {
                var row = rs.rows.item(i);
                scoreModel.append({
                                      "place": (i+1),
                                      "board" : row.boardSize,
                                      "name": row.name,
                                      "score": row.score,
                                      "level" : row.level,
                                      "date":  Qt.formatDate(row.created, "yyyy-MM-dd")})
            }

            while(i++ < limit) {
                scoreModel.append({
                                      "place": (i),
                                      "board" : boardSize,
                                      "name": "?",
                                      "score": 0,
                                      "level": 0,
                                      "date": ""
                })
            }
        }
    });
}
