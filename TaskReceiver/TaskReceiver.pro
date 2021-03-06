QT  += \
    quick \
    network \
    positioning \
    concurrent \
    core

SOURCES += \
        controller.cpp \
        listener.cpp \
        main.cpp \
        tasklist.cpp \
        taskmodel.cpp \
        tasksender.cpp

RESOURCES += qml.qrc

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    controller.h \
    listener.h \
    tasklist.h \
    taskmodel.h \
    tasksender.h
