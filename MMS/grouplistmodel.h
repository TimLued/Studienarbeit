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
        colorRole
    };

    Q_INVOKABLE bool createGroup(const QString & id);
    Q_INVOKABLE void setGroupColor(const QString & id,QString color);
    Q_INVOKABLE void addMember(const QString & id,QString member);
    Q_INVOKABLE void removeMember(const QString & id,QString member);
    Q_INVOKABLE void setVisibility(const QString & id,bool visibility);
    Q_INVOKABLE QString getVisibility(const QString & id);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int,QByteArray>roleNames()const override;


private:
    QList<Group> mGroups;
};

#endif // GROUPLISTMODEL_H
