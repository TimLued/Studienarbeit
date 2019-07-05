#ifndef DRONELISTMODEL_H
#define DRONELISTMODEL_H

#include <QAbstractListModel>
#include <QGeoCoordinate>
#include <drone.h>

class QQmlContext;
class NodeModel;


#include <iostream>

struct Data {
  QGeoCoordinate coord;
  double angle;
  QVariantList infos;
  QVariantList infoNames;
};

struct Info{
    Q_GADGET
    Q_PROPERTY(QString name MEMBER name)
    Q_PROPERTY(QString value MEMBER value)
public:
    QString name;
    QString value;
    Info(const QString& name="", const QString& value=""){
        this->name = name;
        this->value = value;
    }
};

Q_DECLARE_METATYPE(Data)
Q_DECLARE_METATYPE(Info)

class DroneListModel: public QAbstractListModel
{
    Q_OBJECT

public:
    explicit  DroneListModel(QObject *parent = nullptr);

    enum Roles{
        IdRole = Qt::UserRole + 1,
        PosRole,
        ColorRole,
        TrackingRole,
        HistoryRole,
        FollowRole,
        AngleRole,
        InfoNamesRole,
        InfoRole,
        AnimationStateRole,
        VisibleRole
    };

    void register_object(const QString &droneId,
                          QQmlContext *context);

    Q_INVOKABLE bool updateDrone(const QString & jInfo);
    Q_INVOKABLE bool createDrone(const QString & id,QGeoCoordinate coord);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE void setColor(const QString &id,QString color);
    Q_INVOKABLE void toggleHistoryTracking(const QString & id);
    Q_INVOKABLE void toggleFollow(const QString & id);
    Q_INVOKABLE void setVisibility(const QString & id,bool visibility);
    Q_INVOKABLE QVariant getInfoNameList(const QString&id);
    Q_INVOKABLE void setSeelectedInfoList(const QString&id,QString info);
    Q_INVOKABLE void setUnselectedInfoList(const QString&id,QString info);
    Q_INVOKABLE QVariant getAllDronePos();

private:
    QList<Drone> mDrones;
    NodeModel *model;
    QList<QString> colors = {"red","blue","green","purple","yellow","cyan","coral","chartreuse","darkorange","darkred","fuchsia"};
    QList<QString> usedColors;
};

#endif // DRONELISTMODEL_H
