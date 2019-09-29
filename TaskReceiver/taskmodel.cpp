#include "taskmodel.h"
#include "tasklist.h"

TaskModel::TaskModel(QObject *parent)
    : QAbstractListModel(parent),
      mList(nullptr)
{
}

int TaskModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()||!mList)
        return 0;

    return mList->tasks().size();
}

QVariant TaskModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()||!mList)
        return QVariant();

    const TaskItem item = mList->tasks().at(index.row());

    switch(role){
    case TextRole:
        return QVariant(item.text);
    case StatusRole:
        return QVariant(item.sent);
    }
    return QVariant();
}

bool TaskModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(!mList)
        return false;

    TaskItem item = mList->tasks().at(index.row());
    switch(role){
    case TextRole:
        item.text = value.toString();
        break;
    case StatusRole:
        item.sent = value.toBool();
        break;
    }

    if (mList->setTaskAt(index.row(),item)) {
        emit dataChanged(index, index, QVector<int>() << role);
        return true;
    }
    return false;
}

Qt::ItemFlags TaskModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return Qt::ItemIsEditable;
}

QHash<int, QByteArray> TaskModel::roleNames() const
{
    QHash<int,QByteArray>names;
    names[TextRole]="text";
    names[StatusRole]="status";
    return names;
}

TaskList *TaskModel::list() const
{
    return mList;
}

void TaskModel::setList(TaskList *list)
{
    beginResetModel();
    if(mList)
        mList->disconnect(this);
    mList = list;

    if(mList){
        connect(mList,&TaskList::preTaskAppended,this,[=](){
            const int index = mList->tasks().size();
            beginInsertRows(QModelIndex(),index,index);
        });
        connect(mList,&TaskList::postTaskAppended,this,[=](){
            endInsertRows();
        });
        connect(mList,&TaskList::preTaskRemoved,this,[=](int index){
            beginRemoveRows(QModelIndex(),index,index);
        });
        connect(mList,&TaskList::postTaskRemoved,this,[=](){
            endRemoveRows();
        });
        endResetModel();
    }

}
