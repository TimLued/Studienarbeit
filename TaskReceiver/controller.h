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
    explicit Controller(QObject *parent = nullptr);
    ~Controller();

private slots:
    void newCurrentTask(QString taskInfo);

private:
    Listener* taskListener;
    TaskSender* taskSender;
    QThread* listenThread;
    QThread* taskThread;

signals:
    void startListening();
    void newTask();
    void taskSent();
    void taskReceived(QString);
};


#endif // CONTROLLER_H
