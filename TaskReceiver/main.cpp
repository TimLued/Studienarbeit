#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QJsonDocument>
#include <QtCore>

#include <controller.h>
#include <tasklist.h>
#include <taskmodel.h>


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<TaskModel>("Task",1,0,"TaskModel");
    qmlRegisterUncreatableType<TaskList>("Task",1,0,"TaskList",QStringLiteral("TaskList should not be created in QML"));

    TaskList taskList;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("taskList"),&taskList);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    Controller c;

    QObject::connect(&c, &Controller::newTask, [&taskList, &c]() {
        //current task in json format
        QJsonObject jsonResponse = QJsonDocument::fromJson(c.currentTask.toUtf8()).object();
        taskList.appendTask(c.currentTask);
    });

    c.startListening();

    return app.exec();
}
