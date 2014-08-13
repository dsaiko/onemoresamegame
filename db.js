/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */

var db = null;


function dbInit() {
    if(db) return;

    db = Sql.LocalStorage.openDatabaseSync("OneMoreSameGame", "2.0", "OneMoreSameGame High Scores", 100);

    db.transaction(function(tx) {
        tx.executeSql(
           'CREATE TABLE IF NOT EXISTS \
            topten(\
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

    var dataStr = "INSERT INTO topten VALUES(?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
    var data = [playerName, roomNumber, boardSize, level, totalScore];

    db.transaction(function(tx) {
        tx.executeSql(dataStr, data);

        //clean up the scores
        tx.executeSql(
            'delete from topten where roomNumber!=?',
            [roomNumber]
        );

        tx.executeSql(
            'delete \
             from \
                topten \
             where \
                boardSize=? \
                and roomNumber=? \
                and rowid not in ( \
                    select rowid from topten \
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

        var boardSizes = tx.executeSql('select distinct boardSize from topten where roomNumber=? order by boardSize', [roomNumber]);
        var limit = 3

        for(var n=0; n < boardSizes.rows.length; n++) {
            var boardSize = boardSizes.rows.item(n).boardSize;

            var rs = tx.executeSql(
                        'select * from topten where boardSize=? and roomNumber=? and score >= 0 order by score desc limit ?',
                        [boardSize, roomNumber, limit]
            );


            var i = 0;
            for(; i < rs.rows.length; i++) {
                var row = rs.rows.item(i);
                scoreModel.append({
                                      "place": (i+1),
                                      "board" : row.boardSize,
                                      "name":   row.name.substring(0,10),
                                      "score":  row.score,
                                      "level" : qsTr("lv.")+row.level,
                                      "date":   Qt.formatDate(row.created, "yyyy-MM-dd")})
            }

            while(i++ < limit) {
                scoreModel.append({
                                      "place": (i),
                                      "board" : boardSize,
                                      "name": "?",
                                      "score": 0,
                                      "level": "",
                                      "date": ""
                })
            }
        }
    });
}


function saveResponse(result) {

    dbInit();

    db.transaction(function(tx) {
        //clean up the scores
        tx.executeSql(
            'delete from topten where roomNumber=?',
            [roomNumber]
        );

        var dataStr = "INSERT INTO topten VALUES(?, ?, ?, ?, ?, ?)";

        for(var i=0; i<result.length; i++) {
            var row = result[i];
            var data = [row.name, row.roomNumber, row.boardSize, row.level, row.score, row.created];
            tx.executeSql(dataStr, data);
        }
    });

    reloadScore();

}

function syncScore() {
    dbInit()

    var postData = ""

    db.transaction(function(tx) {

        var boardSizes = tx.executeSql('select distinct boardSize from topten where roomNumber=? order by boardSize', [roomNumber]);
        var limit = 3

        var data=[]


        for(var n=0; n < boardSizes.rows.length; n++) {
            var boardSize = boardSizes.rows.item(n).boardSize;

            var rs = tx.executeSql(
                        'select * from topten where boardSize=? and roomNumber=? order by score desc limit ?',
                        [boardSize, roomNumber, limit]
            );


            var i = 0;


            for(; i < rs.rows.length; i++) {
                var row = rs.rows.item(i);
                data.push(row);
            }

        }

        if(data.length === 0) {
            //in case there is no data we need to send something
            var rs = tx.executeSql(
                        "select '?' as name, ? as roomNumber, '10x15' as boardSize, 1 as level, 0 as score, CURRENT_TIMESTAMP as created",
                        [roomNumber]
            );
            for(var i=0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i);
                data.push(row);
            }
        }

        postData = JSON.stringify(data);
    });


    var postman = new XMLHttpRequest()
    postman.open("POST", "http://cgi.samegame.saiko.cz/topten.php", true);
    postman.setRequestHeader("Content-Type", "application/json");
    postman.setRequestHeader("Origin", "OneMoreSameGame");
    postman.onreadystatechange = function() {
          if (postman.readyState == postman.DONE) {
              if(postman.status == 200) {
                  var result = JSON.parse(postman.responseText)
                  if(result)
                    saveResponse(result);
              }
          }
    }
    postman.send(postData);

}
