#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <controller.h>

#include <dronelistmodel.h>
#include <grouplistmodel.h>

#include <iostream>

void update(){

}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);


    DroneListModel droneModel;
    GroupListModel groupModel;

    QQmlApplicationEngine  engine;

    droneModel.register_object("dronemodel",engine.rootContext());
    groupModel.register_object("groupmodel",engine.rootContext());
    qmlRegisterType<Controller>("Controller",1,0,"Controller");


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty()) return -1;

    Controller c;
    QObject::connect(&c, &Controller::posUpdated, [&droneModel, &c]() {
        //json input
        droneModel.updateDrone(c.currentDroneInfo);
    });
    c.startListener();

    return app.exec();
}
