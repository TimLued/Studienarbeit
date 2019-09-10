#include "grouplistmodel.h"

GroupListModel::GroupListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

void GroupListModel::register_object(const QString &groupId,QQmlContext *context){
    context->setContextProperty(groupId, this);
}

void GroupListModel::createGroup()
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    Group group;
    QString name;
    for(int i=1;;i++){//new not exiting name
        name = "Gruppe "+ QString::number(i);
        auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == name;});
        if(it == mGroups.end()) break;
    }
    group.sedId(name);
    group.setColor("black");
    mGroups<<group;
    endInsertRows();
}

void GroupListModel::deleteGroup(const QString &id)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    beginRemoveRows(QModelIndex(),ix.row(),ix.row());
    mGroups.removeAt(ix.row());
    endRemoveRows();
}

void GroupListModel::setGroupColor(const QString &id, QString color)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    mGroups[ix.row()].setColor(color);
    emit dataChanged(ix, ix, QVector<int>{colorRole});
}

void GroupListModel::setGroupId(const QString &id, QString newId)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    mGroups[ix.row()].sedId(newId);
    emit dataChanged(ix, ix, QVector<int>{idRole});
}

bool GroupListModel::addMember(const QString &id, QString member)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    if(it == mGroups.end()) return false;
    QModelIndex ix = index(it - mGroups.begin());
    if(mGroups[ix.row()].members().contains(member))return false;
    mGroups[ix.row()].addMember(member);
    emit dataChanged(ix, ix, QVector<int>{membersRole});
    return true;
}

bool GroupListModel::containsMember(const QString &id, QString member)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
     if(mGroups[ix.row()].members().contains(member))
         return true;
     else return false;
}

QVariant GroupListModel::getMembers(const QString &id)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    return mGroups[ix.row()].members();
}

void GroupListModel::removeMember(const QString &id, QString member)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    mGroups[ix.row()].removeMember(member);
    emit dataChanged(ix, ix, QVector<int>{membersRole});
}

void GroupListModel::setVisibility(const QString &id, bool visible)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    mGroups[ix.row()].setVisible(visible);
    emit dataChanged(ix, ix, QVector<int>{visibleRole});
}

QString GroupListModel::getGroupColor(const QString &id)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    QModelIndex ix = index(it - mGroups.begin());
    return mGroups[ix.row()].color();
}

void GroupListModel::setFollow(const QString &id, bool follow)
{
    auto it = std::find_if(mGroups.begin(), mGroups.end(), [&](Group const& obj){return obj.id() == id;});
    int row = it - mGroups.begin();
    QModelIndex ix = index(row);
    it->setFollow(follow);
    emit dataChanged(ix, ix, QVector<int>{followRole});

    //others set false
    for (int i=0;i<mGroups.count();i++){
        if(i != row && mGroups[i].follow()) {
            mGroups[i].setFollow(false);
            emit dataChanged(index(i), index(i), QVector<int>{followRole});
        }
    }

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
        case visibleRole:
            return it.visible();
        case followRole:
            return it.follow();
        }
    }

    return QVariant();
}

QHash<int, QByteArray> GroupListModel::roleNames() const
{
    QHash<int,QByteArray>roles;
    roles[idRole]="idInfo";
    roles[colorRole]="colorInfo";
    roles[membersRole]="memberInfo";
    roles[visibleRole]="visibleInfo";
    roles[followRole]="followInfo";

    return roles;
}



