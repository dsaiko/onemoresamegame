
function saveScore(playerName, nx, ny, level, totalScore) {

    var db = Sql.LocalStorage.openDatabaseSync("OneMoreSameGame", "1.0", "OneMoreSameGame High Scores", 100);

    console.log('Saving score', playerName, nx, ny, level, mainWindow.totalScore, db.type)

    var boardSize = nx + "x" + ny;

    var dataStr = "INSERT INTO topscores VALUES(?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
    var data = [playerName, 1, boardSize, level, totalScore];

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS topscores(name TEXT, isLocalScore BOOL, boardSize TEXT, level NUMBER, score NUMBER, created TEXT)');
        tx.executeSql(dataStr, data);

        //clean up the table scores
        tx.executeSql('delete from topscores where isLocalScore=1 and boardSize=? and rowid not in (select rowid from topscores where isLocalScore=1 and boardSize=? order by score desc limit 10)',
                      [boardSize, boardSize]);
    });
}



