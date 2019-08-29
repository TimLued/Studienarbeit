QT  += \
    quick \
    network \
    positioning \
    concurrent \
    core \

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
        controller.cpp \
        dronelistmodel.cpp \
        main.cpp \
        posupdater.cpp \
        tasksender.cpp

RESOURCES += \
    qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    controller.h \
    drone.h \
    dronelistmodel.h \
    posupdater.h \
    tasksender.h

DISTFILES +=
