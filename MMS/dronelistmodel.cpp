#include <dronelistmodel.h>
#include "nodemodel.h"
#include <QGeoCoordinate>

#include <QQmlContext>

DroneListModel::DroneListModel(QObject *parent):QAbstractListModel(parent) {
    model = new NodeModel(this);
}

void DroneListModel::register_objects(const QString &droneId,
                      const QString &nodeName,
                      QQmlContext *context){
    context->setContextProperty(droneId, this);
    context->setContextProperty(nodeName, model);
}

bool DroneListModel::updateDrone(const QString & id,QGeoCoordinate coord,int angle){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    if(it != mDrones.end()){
        //append
        int row = it - mDrones.begin();
        QModelIndex ix = index(row);

        QGeoCoordinate c = ix.data(PosRole).value<QGeoCoordinate>();
        //int a = ix.data(AngleRole).toInt();
        Data data{coord, angle};
        bool result = setData(ix, QVariant::fromValue(data), PosRole);
        if (result)
            model->appendNode(c);
        return result;
    }else{
        //create
        return createDrone(coord, id);
    }

}

bool DroneListModel::createDrone(QGeoCoordinate coord, const QString & id){
   beginInsertRows(QModelIndex(), rowCount(), rowCount());

   Drone it;
   it.sedId(id);
   it.setPos(coord);
   it.setColor("red");
   mDrones<< it;
   endInsertRows();
   return true;
}

bool DroneListModel::toggleFollow(const QString &id){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    int row = it - mDrones.begin();
    QModelIndex ix = index(row);

    it->setFollow();
    emit dataChanged(ix, ix, QVector<int>{FollowRole});

    //others set false
    for (int i=0;i<mDrones.count();i++){
        if(i != row && mDrones[i].following()) {
            mDrones[i].setFollow();
            emit dataChanged(index(i), index(i), QVector<int>{FollowRole});
        }
    }
    return true;
}

bool DroneListModel::toggleHistoryTracking(const QString &id){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    int row = it - mDrones.begin();
    QModelIndex ix = index(row);

    it->setTrackHistory();
    emit dataChanged(ix, ix, QVector<int>{HistoryRole});

    //others set false
    for (int i=0;i<mDrones.count();i++){
        if(i != row && mDrones[i].trackingHistory()) {
            mDrones[i].setTrackHistory();
            emit dataChanged(index(i), index(i), QVector<int>{HistoryRole});
        }
    }
    return true;
}

QVariant DroneListModel::getDroneHistory(const QString &id){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    return it->getHistory();
}

void DroneListModel::setColor(const QString &id, QString color){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    it->setColor(color);
    QModelIndex ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{ColorRole});
}

 int DroneListModel::rowCount(const QModelIndex &parent) const {
   Q_UNUSED(parent)
   return mDrones.count();
 }

 QVariant DroneListModel::data(const QModelIndex &index, int role) const {
     if (!index.isValid())
         return QVariant();
     if (index.row() >= 0 && index.row() < rowCount()) {
         const Drone &it = mDrones[index.row()];
         if (role == IdRole)
             return it.id();
         else if (role == PosRole)
             return QVariant::fromValue(it.pos());
         else if (role == ColorRole)
             return it.getColor();
         else if (role == AngleRole)
             return it.getAngle();
         else if(role == HistoryRole)
             return it.trackingHistory();
         else if(role == FollowRole)
             return it.following();
     }
     return QVariant();
 }

 QHash<int, QByteArray> DroneListModel::roleNames() const {
   QHash<int, QByteArray> roles;
   roles[IdRole] = "idInfo";
   roles[PosRole] = "posInfo";
   roles[AngleRole] = "angleInfo";
   roles[ColorRole] = "colorInfo";
   roles[HistoryRole] = "trackingHistoryInfo";
   roles[FollowRole] = "followInfo";
   return roles;
 }

 bool DroneListModel::setData(const QModelIndex &index, const QVariant &value,
                              int role) {
   if (!index.isValid())
     return false;
   if (index.row() >= 0 && index.row() < rowCount()) {
     if (role == PosRole) {
       const Data &data = value.value<Data>();
       QGeoCoordinate new_pos(data.coord);
       mDrones[index.row()].setPos(new_pos);
       mDrones[index.row()].setAngle(data.angle);
       emit dataChanged(index, index, QVector<int>{PosRole});
       return true;
     }
   }
   return false;
 }


