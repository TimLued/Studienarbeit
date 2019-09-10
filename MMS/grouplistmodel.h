#ifndef GROUPLISTMODEL_H
#define GROUPLISTMODEL_H

#include <QAbstractListModel>
#include <QQmlContext>
#include <group.h>


class GroupListModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit GroupListModel(QObject *parent = nullptr);
    void register_object(const QString &groupId,QQmlContext *context);
    enum {
        idRole = Qt::UserRole,
        membersRole,
        colorRole,
        visibleRole,
        followRole
    };

    Q_INVOKABLE void createGroup();
    Q_INVOKABLE void deleteGroup(const QString & id);
    Q_INVOKABLE void setGroupColor(const QString & id,QString color);
    Q_INVOKABLE void setGroupId(const QString & id,QString newId);
    Q_INVOKABLE bool addMember(const QString & id,QString member);
    Q_INVOKABLE bool containsMember(const QString & id,QString member);
    Q_INVOKABLE QVariant getMembers(const QString & id);
    Q_INVOKABLE void removeMember(const QString & id,QString member);
    Q_INVOKABLE void setVisibility(const QString & id,bool visible);
    Q_INVOKABLE QString getGroupColor(const QString & id);
    Q_INVOKABLE void setFollow(const QString & id,bool follow);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int,QByteArray>roleNames()const override;


private:
    QList<Group> mGroups;
};

#endif // GROUPLISTMODEL_H
