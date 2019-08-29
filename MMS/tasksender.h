#ifndef TASKSENDER_H
#define TASKSENDER_H

#include <QObject>
class QLocalServer;

class TaskSender: public QObject
{
    Q_OBJECT
public:
    explicit TaskSender(QObject *parent = nullptr);

public slots:
    void setTask(QString taskInfo);

private:
    QLocalServer *server;
    void serverError();
    bool sendTask();
    QString m_task;

};

#endif // TASKSENDER_H
