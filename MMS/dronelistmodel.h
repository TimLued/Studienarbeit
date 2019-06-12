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
  int angle;
};
Q_DECLARE_METATYPE(Data)



class DroneListModel: public QAbstractListModel
{
    Q_OBJECT

public:
    explicit  DroneListModel(QObject *parent = nullptr);

    enum AirportsRoles{
        IdRole = Qt::UserRole + 1,
        PosRole,
        ColorRole,
        FollowRole,
        AngleRole
    };

    void register_objects(const QString &droneId,
                          const QString &nodeName,
                          QQmlContext *context);

    Q_INVOKABLE bool updateDrone(const QString & id,QGeoCoordinate coord,bool follow = false,int angle = 0);
    Q_INVOKABLE bool createDrone(QGeoCoordinate coord, const QString & id);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    bool setData(const QModelIndex &index, const QVariant &value, int role) override;

    Q_INVOKABLE QVariant getDroneHistory(const QString&id);
    Q_INVOKABLE void setColor(const QString &id,QString color);
private:
    QList<Drone> mDrones;
    NodeModel *model;

};

#endif // DRONELISTMODEL_H
