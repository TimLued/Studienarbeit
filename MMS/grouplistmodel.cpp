#include "grouplistmodel.h"

GroupListModel::GroupListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

void GroupListModel::register_object(const QString &groupId,QQmlContext *context){
    context->setContextProperty(groupId, this);
}

bool GroupListModel::createGroup(const QString &id)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    if(it == mGroups.end()){
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        Group group;
        group.sedId(id);
        group.setColor("black");
        mGroups<<group;
        endInsertRows();
        return true;
    }
    return false;
}

void GroupListModel::setGroupColor(const QString &id, QString color)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    mGroups[ix.row()].setColor(color);
    emit dataChanged(ix, ix, QVector<int>{colorRole});
}

void GroupListModel::addMember(const QString &id, QString member)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    mGroups[ix.row()].addMember(member);
    emit dataChanged(ix, ix, QVector<int>{membersRole});
}

void GroupListModel::removeMember(const QString &id, QString member)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    mGroups[ix.row()].removeMember(member);
    emit dataChanged(ix, ix, QVector<int>{membersRole});
}

void GroupListModel::setVisibility(const QString &id, bool visibility)
{

}

QString GroupListModel::getVisibility(const QString &id)
{

}

int GroupListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mGroups.count();
}

QVariant GroupListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();
    if (index.row() >= 0 && index.row() < rowCount()) {
        const Group &it = mGroups[index.row()];

        switch(role){
        case idRole:
            return it.id();
        case colorRole:
            return it.color();
        case membersRole:
            return it.members();
        }
    }

    return QVariant();
}

QHash<int, QByteArray> GroupListModel::roleNames() const
{
    QHash<int,QByteArray>names;
    names[idRole]="idInfo";
    names[colorRole]="colorInfo";
    names[membersRole]="memberInfo";
    return names;
}



