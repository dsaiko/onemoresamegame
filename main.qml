/**
  * OneMoreSamegame
  * http://www.samegame.saiko.cz/
  * (c) 2014 Dušan Saiko dusan.saiko@gmail
  * Apache License 2.0
  */
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Window 2.0

//code signoff date: 2014-08-16
ApplicationWindow {
    id:                                     mainWindow
    visible:                                true
    height:                                 Screen.height * 2 / 3
    width:                                  Screen.width / 2

    minimumWidth:                           200
    minimumHeight:                          200
    title:                                  "One More SameGame " + PlatformDetails.appVersion

    property alias totalScore:              scoreBar.totalScore

    Background {
           anchors.fill:                    parent
    }

    AppStatusBar {
         id:                                scoreBar

         width:                             parent.width
         height:                            parent.height / 20
         anchors.bottom:                    parent.bottom

         onMenuDisplay:                     board.menuDisplay()
         onMenuHide:                        board.menuDisplay()

         level:                             board.level
    }

    Board {
         id:                                board

         width:                             parent.width
         height:                            parent.height - scoreBar.height
         onResetScore:                      scoreBar.resetScore()
         onScoreChanged:                    scoreBar.scoreAdded(count, numberOfColors)
    }
}
