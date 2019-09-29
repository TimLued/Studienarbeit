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

Controller::Controller(QObject *parent):
    QObject(parent)
{
    up = new PosUpdater;
    t1 = new QThread;
    up->moveToThread(t1);
    connect(this, SIGNAL(startListener()), up, SLOT(requestPos()));
    connect(up, SIGNAL(posUpdated(QString)), this, SLOT(updateCurrent(QString)));
    connect(t1, &QThread::finished, t1, &QThread::deleteLater);
    t1->start();

    taskSender = new TaskSender;
    t2 = new QThread;
    taskSender->moveToThread(t2);
    connect(this,SIGNAL(taskChanged(QString)),taskSender,SLOT(appendTask(QString)));
    t2->start();
}




