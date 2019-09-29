#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QThread>
#include <tasksender.h>
#include <listener.h>

class Controller: public QObject
{
    Q_OBJECT
public:
    QString currentTask;

    Controller(){
        TaskListener = new Listener;
        t = new QThread;
        TaskListener->moveToThread(t);
        connect(this, SIGNAL(startListening()), TaskListener, SLOT(requestTask()));
        connect(TaskListener, SIGNAL(taskReceived(QString)), this, SLOT(newCurrentTask(QString)));
        connect(t, &QThread::finished, t, &QThread::deleteLater);
        t->start();

        taskSender = new TaskSender;
        t2 = new QThread;
        taskSender->moveToThread(t2);
        connect(TaskListener,SIGNAL(taskReceived(QString)),taskSender,SLOT(appendTask(QString)));
        //connect(taskSender,SIGNAL(taskSent()),this,SIGNAL(taskSent()));
        t2->start();
    }

private slots:
    void newCurrentTask(QString taskInfo){
        currentTask = taskInfo;
        emit newTask();
    }
private:
    Listener* TaskListener;
    TaskSender* taskSender;
    QThread* t;
    QThread* t2;

signals:
    void startListening();
    void newTask();
    void taskSent();
};


#endif // CONTROLLER_H
