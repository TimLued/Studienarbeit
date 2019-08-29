#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QThread>

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
    }

private slots:
    void newCurrentTask(QString taskInfo){
        currentTask = taskInfo;
        emit newTask();
    }
private:
    Listener* TaskListener;
    QThread* t;

signals:
    void startListening();
    void newTask();
};


#endif // CONTROLLER_H
