#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <controller.h>
#include <QQmlContext>

#include <transsmoother.h>

#include <dronelistmodel.h>


#include <iostream>
#include <QGeoPath>

void update(){

}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    Controller c;

    DroneListModel droneModel;

    QQmlApplicationEngine  engine;
    droneModel.register_object("dronemodel",engine.rootContext());

    //EDIT!!
    qmlRegisterType<TransSmoother>("TransSmoother", 1, 0, "TransSmoother");

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    QObject::connect(&c, &Controller::posUpdated, [&droneModel, &c]() {
        //json input
        droneModel.updateDrone(c.currentInfo);
    });


    c.start();

    return app.exec();
}
