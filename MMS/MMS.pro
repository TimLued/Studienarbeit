QT  += \
    quick \
    network \
    positioning \
    concurrent



CONFIG += c++11

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
        main.cpp \
        posupdater.cpp \
        transsmoother.cpp

RESOURCES += qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    controller.h \
    posupdater.h \
    transsmoother.h
