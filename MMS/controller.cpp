#include "controller.h"

QString Controller::task()
{
    return m_Task;
}

void Controller::setTask(const QString &taskInfo)
{
    m_Task = taskInfo;
    emit taskChanged(m_Task);
}

void Controller::updateCurrent(QString droneInfo)
{
    currentDroneInfo = droneInfo;
    emit posUpdated();
}

Controller::Controller(QObject *parent):
    QObject(parent)
{
    posUpdater = new PosUpdater;
    posUpdater->setTupeName("dronespos",1);
    t1 = new QThread;
    posUpdater->moveToThread(t1);
    connect(this, SIGNAL(startListener()), posUpdater, SLOT(requestPos()));
    connect(posUpdater, SIGNAL(posUpdated(QString)), this, SLOT(updateCurrent(QString)));
    connect(t1, &QThread::finished, t1, &QThread::deleteLater);
    t1->start();

    taskSender = new TaskSender;
    t2 = new QThread;
    taskSender->moveToThread(t2);
    connect(t2, &QThread::finished, t2, &QThread::deleteLater);
    connect(this,SIGNAL(taskChanged(QString)),taskSender,SLOT(appendTask(QString)));
    t2->start();

    taskUpdater = new PosUpdater;
    taskUpdater->setTupeName("dronestask",10);
    t3 = new QThread;
    taskUpdater->moveToThread(t3);
    connect(t3, &QThread::finished, t3, &QThread::deleteLater);
    connect(this, SIGNAL(startListener()), taskUpdater, SLOT(requestPos()));
    connect(taskUpdater, SIGNAL(posUpdated(QString)), this, SLOT(updateCurrent(QString)));
    t3->start();
}




