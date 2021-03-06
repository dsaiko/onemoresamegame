/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
var db = null;

//code signoff date: 2014-08-16
var gameID = "?"

function dbInit() {
    if(db) return;

    db = Sql.LocalStorage.openDatabaseSync("OneMoreSameGame", "1.0", "OneMoreSameGame TopTen Scores", 100);
    db.transaction(function(tx) {
        tx.executeSql(
           'CREATE TABLE IF NOT EXISTS \
            topten(\
                gameID TEXT, \
                name TEXT, \
                roomNumber TEXT, \
                boardSize TEXT, \
                level NUMBER, \
                score NUMBER, \
                created TEXT, \
                UNIQUE (roomnumber, boardsize, name, level, score, created) ON CONFLICT REPLACE \
            )');
    });
}

function saveScore(playerName, boardGridWidth, boardGridHeight, level, totalScore, boardSize) {
    dbInit();
    if(level === 1) {
        gameID =  generateUUID("????-????");
    }

    db.transaction(function(tx) {
        //remove records from previous room nubmers
        tx.executeSql('delete from topten where roomNumber!=?', [roomNumber]);

        if(level === 1) {
            //reset games in db
            tx.executeSql('update topten set gameID=? where roomNumber=?', ['N/A', roomNumber]);
        } else {
            //remove previous scores from the same game
            tx.executeSql('delete from topten where roomNumber=? and gameID=?', [roomNumber,gameID]);
        }

        //insert score
        tx.executeSql("INSERT INTO topten VALUES(?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)",
                      [gameID, playerName, roomNumber, boardSize, level, totalScore]
        );

        tx.executeSql(
            'delete from topten where boardSize=? and roomNumber=? and rowid not in ( \
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

        var boardSizes = [ "*", "**", "***", "****"]
        var limit = 3

        for(var n=0; n < boardSizes.length; n++) {
            var boardSize = boardSizes[n];

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
        var dataStr = "INSERT INTO topten VALUES(?, ?, ?, ?, ?, ?, ?)";

        for(var i=0; i<result.length; i++) {
            var row = result[i];
            var data = ['N/A', row[0], row[1], row[2], row[3], row[4], row[5]];
            tx.executeSql(dataStr, data);
        }
    });

    reloadScore();
}

function syncScore() {
    loadingAnimation.error = false;
    loadingAnimation.visible = true;
    dbInit()

    var postData = ""

    db.transaction(function(tx) {

        var boardSizes = tx.executeSql('select distinct boardSize from topten where roomNumber=? order by boardSize', [roomNumber]);
        var limit = 3

        var data=[]


        for(var n=0; n < boardSizes.rows.length; n++) {
            var boardSize = boardSizes.rows.item(n).boardSize;

            var rs = tx.executeSql(
                        'select name, roomNumber, boardSize, level, score, created from topten where boardSize=? and roomNumber=? order by score desc limit ?',
                        [boardSize, roomNumber, limit]
            );


            var i = 0;


            for(; i < rs.rows.length; i++) {
                var row = rs.rows.item(i);
                data.push(row);
            }

        }

        if(data.length === 0) {
            //in case there is no data we need to send something to provide room number
            var rs = tx.executeSql(
                        "select '?' as name, ? as roomNumber, '*' as boardSize, 1 as level, 0 as score, CURRENT_TIMESTAMP as created",
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
    //note: these system info headers do not query OS for any kind of information,
    //they just use pre defined macros from standard QT, see osversion.cpp
    //if you want ot use cgi.samegame.saiko.cz for storing topten results,
    //you should keep the headers in place
    postman.open("POST", "http://cgi.samegame.saiko.cz/topten.php", true);
    postman.setRequestHeader("Content-Type", "application/json");
    postman.setRequestHeader("Origin", "OneMoreSameGame");
    postman.setRequestHeader("AppVersion", PlatformDetails.appVersion);
    postman.setRequestHeader("BuildDate", PlatformDetails.buildDate);
    postman.setRequestHeader("OsType", PlatformDetails.osType);
    postman.setRequestHeader("OsVersion", PlatformDetails.osVersion);
    postman.setRequestHeader("Locale", Qt.locale().name);

    postman.onreadystatechange = function() {
          if (postman.readyState == postman.DONE) {              
              if(postman.status == 200) {
                  loadingAnimation.visible = false;
                  if(postman.responseText && postman.responseText !== "[]") {
                      var result = JSON.parse(postman.responseText)
                      if(result && result.length > 0)
                        saveResponse(result);
                  }
              } else {
                  loadingAnimation.error = true;
                  loadingAnimation.hideTimer.start();
              }
          }
    }
    postman.send(postData);
}
