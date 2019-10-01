#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QString>
#include <posupdater.h>
#include <QThread>
#include <QGeoPositionInfoSource>
#include <QGeoCoordinate>

#include <tasksender.h>
#include <iostream>

class Controller: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString task READ task WRITE setTask NOTIFY taskChanged)
public:
    explicit Controller(QObject *parent = nullptr);

    QString currentDroneInfo;
    QString task();
    void setTask(const QString &taskInfo);

private slots:
    void updateCurrent(QString droneInfo);

private:
   PosUpdater* posUpdater;
   QThread* t1;

   TaskSender* taskSender;
   QThread* t2;

   PosUpdater* taskUpdater;
   QThread* t3;
   QString m_Task;


signals:
    void startListener();
    void posUpdated();
    void taskChanged(QString taskInfo);
};

#endif // CONTROLLER_H
