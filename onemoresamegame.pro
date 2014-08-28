TEMPLATE = app

QT += qml quick sql

lupdate_only{
    SOURCES += *.qml *.js
}

SOURCES += main.cpp osversion.cpp


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    platform-details.h

RC_FILE = onemoresamegame.rc

TRANSLATIONS =  translations/onemoresamegame_cz.ts     \
                translations/onemoresamegame_fr.ts     \
                translations/onemoresamegame_de.ts     \
                translations/onemoresamegame_en.ts

OTHER_FILES +=

