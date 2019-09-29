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
    void appendTask(QString taskInfo);

private:
    QLocalServer *server;
    bool sendTask();
    QList<QString> m_task;

signals:
    void taskSent();
};

#endif // TASKSENDER_H
