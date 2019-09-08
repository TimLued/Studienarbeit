#include "tasklist.h"

TaskList::TaskList(QObject *parent) : QObject(parent)
{
//    mTasks.append({QStringLiteral("Test 1"),false});
//    mTasks.append({QStringLiteral("Test 2"),false});
}

QVector<TaskItem> TaskList::tasks() const
{
    return mTasks;
}

bool TaskList::setTaskAt(int index, const TaskItem &task)
{
    if (index < 0 || index >= mTasks.size())
        return false;

    const TaskItem &oldTask = mTasks.at(index);
    if (task.text == oldTask.text)
        return false;

    mTasks[index] = task;
    return true;
}

void TaskList::appendTask(QString data)
{
    emit preTaskAppended();
    TaskItem task;
    task.done = false;
    task.text = data;
    mTasks.append(task);
    emit postTaskAppended();
}

void TaskList::removeTask(int i)
{
    emit preTaskRemoved(i);
    mTasks.removeAt(i);
    emit postTaskRemoved();
}
