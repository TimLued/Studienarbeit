#include <QGuiApplication>
#include <QQmlApplicationEngine>


#include <QQmlContext>
#include <controller.h>
#include <dronelistmodel.h>

#include <iostream>
#include <QGeoPath>

void update(){

}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);


    DroneListModel droneModel;

    QQmlApplicationEngine  engine;

    droneModel.register_object("dronemodel",engine.rootContext());
    //qmlRegisterType<TransSmoother>("TransSmoother", 1, 0, "TransSmoother");
    qmlRegisterType<Controller>("Controller",1,0,"Controller");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    Controller c;
    QObject::connect(&c, &Controller::posUpdated, [&droneModel, &c]() {
        //json input
        droneModel.updateDrone(c.currentDroneInfo);
    });
    c.startListener();



    return app.exec();
}
