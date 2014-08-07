var db = null;


function dbInit() {
    if(db) return;

    db = Sql.LocalStorage.openDatabaseSync("OneMoreSameGame", "1.0", "OneMoreSameGame High Scores", 100);

    db.transaction(function(tx) {
        tx.executeSql(
           'CREATE TABLE IF NOT EXISTS \
            topscores(\
                name TEXT, \
                isLocalScore BOOL, \
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
    var data = [playerName, 1, boardSize, level, totalScore];

    db.transaction(function(tx) {
        tx.executeSql(dataStr, data);

        //clean up the table scores
        tx.executeSql(
            'delete \
             from \
                topscores \
             where \
                isLocalScore=1 \
                and boardSize=? \
                and rowid not in ( \
                    select rowid from topscores \
                    where \
                    isLocalScore=1  \
                    and boardSize=? \
                    order by score desc \
                    limit 10 \
                )',
            [boardSize, boardSize]
        );
    });

    reloadScore();
}



function reloadScore() {
    dbInit()
    scoreModel.clear();

    db.transaction(function(tx) {

        var boardSizes = tx.executeSql('select distinct boardSize from topscores order by boardSize');
        var limit = 3

        for(var n=0; n < boardSizes.rows.length; n++) {
            var boardSize = boardSizes.rows.item(n).boardSize;

            var rs = tx.executeSql(
                        'select * from topscores where boardSize=? order by score desc limit ?',
                        [boardSize, limit]
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
