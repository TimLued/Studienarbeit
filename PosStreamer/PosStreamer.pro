#-------------------------------------------------
#
# Project created by QtCreator 2019-05-10T14:04:24
#
#-------------------------------------------------

QT +=   network widgets

SOURCES += \
        clientsocket.cpp \
        main.cpp \
        clientapplication.cpp \
        possource.cpp

HEADERS += \
        clientapplication.h \
        clientsocket.h \
        possource.h

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    logfile.qrc

