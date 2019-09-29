#ifndef TASKLIST_H
#define TASKLIST_H

#include <QObject>
#include <QVector>

struct TaskItem{
    QString text;
    bool sent;
};

class TaskList : public QObject
{
    Q_OBJECT
public:
    explicit TaskList(QObject *parent = nullptr);
    QVector<TaskItem> tasks() const;
    bool setTaskAt(int index,const TaskItem &task);

signals:
    void preTaskAppended();
    void postTaskAppended();
    void preTaskRemoved(int index);
    void postTaskRemoved();

public slots:
    void appendTask(QString data);
    void removeTask(int i);

private:
    QVector<TaskItem> mTasks;
};

#endif // TASKLIST_H
