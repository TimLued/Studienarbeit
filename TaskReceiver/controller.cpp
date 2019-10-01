#include "controller.h"

Controller::Controller(QObject *parent):
    QObject(parent)
{
    taskListener = new Listener;
    listenThread = new QThread;
    taskListener->moveToThread(listenThread);

    connect(listenThread, SIGNAL(finished()), taskListener, SLOT(deleteLater()));
    connect(this, SIGNAL(startListening()), taskListener, SLOT(requestTask())); //start Listener
    connect(taskListener, SIGNAL(taskReceived(QString)), this, SLOT(newCurrentTask(QString)));//t->main
    listenThread->start();


    taskSender = new TaskSender(this);
    //taskThread = new QThread;
    //taskSender->moveToThread(taskThread);
    //connect(taskThread, SIGNAL(finished()), taskSender, SLOT(deleteLater()));
    connect(this, SIGNAL(taskReceived(QString)),taskSender,SLOT(appendTask(QString)));
    //taskThread->start();

}

Controller::~Controller()
{
    listenThread->quit();
    listenThread->wait();
//    taskThread->quit();
//    taskThread->wait();
}

void Controller::newCurrentTask(QString taskInfo)
{
    currentTask = taskInfo;
    emit newTask();
    emit taskReceived(taskInfo);
}


