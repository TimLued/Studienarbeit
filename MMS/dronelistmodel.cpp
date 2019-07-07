#include <dronelistmodel.h>
#include <QGeoCoordinate>
#include <QJsonDocument>
#include <QJsonObject>
#include <QQmlContext>

#include <iostream>

DroneListModel::DroneListModel(QObject *parent):QAbstractListModel(parent) {}

void DroneListModel::register_object(const QString &droneId,
                                     QQmlContext *context){
    context->setContextProperty(droneId, this);
}

bool DroneListModel::updateDrone(const QString & jInfo){

    QJsonObject jDroneInfo = QJsonDocument::fromJson(jInfo.toUtf8()).object();
    const QString id = jDroneInfo["id"].toString();
    QGeoCoordinate coord = QGeoCoordinate(jDroneInfo["lat"].toString().toDouble(),jDroneInfo["lon"].toString().toDouble());

    double angle = jDroneInfo["bearing"].toString().toDouble();

    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});

    if(it != mDrones.end()){
        //append

        QVariantList infos;
        QVariantList infoNames;
        QRegExp re("[+-]?\\d*\\.?\\d+");
        foreach(const QString& key, jDroneInfo.keys()) {

            QString val = jDroneInfo.value(key).toString();

            if (re.exactMatch(val)) val = QString::number(val.toDouble(),'f',3); //round if info is numerical
            Info info{key,val};

            if (it->getSelectedInfoList().indexOf(key) != -1) infos << QVariant::fromValue(info); //add if in selected list

            infoNames << key;
        }

        int row = it - mDrones.begin();
        QModelIndex ix = index(row);

        QGeoCoordinate c = ix.data(PosRole).value<QGeoCoordinate>();
        Data data{coord, angle, infos,infoNames};
        bool result = setData(ix, QVariant::fromValue(data), PosRole);
        return result;
    }else{
        //create
        return createDrone(id, coord);
    }
}

bool DroneListModel::createDrone(const QString & id,QGeoCoordinate coord){
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    Drone it;
    it.sedId(id);
    it.setPos(coord);
    for (int i = 0;i<colors.count();i++){
        if (usedColors.indexOf(colors[i]) == -1){
            it.setColor(colors[i]);
            usedColors.append(colors[i]);
            break;
        }else if (i == colors.count()-1) {usedColors.clear();}
    }
    mDrones<< it;
    endInsertRows();
    return true;
}

void DroneListModel::toggleFollow(const QString &id){
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
}


void DroneListModel::toggleHistoryTracking(const QString &id){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    int row = it - mDrones.begin();
    QModelIndex ix = index(row);

    it->setTrackHistory();
    emit dataChanged(ix, ix, QVector<int>{TrackingRole});
}

QVariant DroneListModel::getInfoNameList(const QString&id){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    return it->getInfoNames();
}


void DroneListModel::setSeelectedInfoList(const QString&id,QString info){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    it->addSelectedInfo(info);
}

void DroneListModel::setUnselectedInfoList(const QString&id,QString info){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    it->removeSelectedInfo(info);
}

QVariant DroneListModel::getAllDronePos(){
    QVariantList dronePos_list;
    for (const Drone &drone:mDrones){
        auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
                return obj.id() == drone.id();});

        dronePos_list<<QVariant::fromValue(it->pos());

    }
    return dronePos_list;
}

void DroneListModel::setColor(const QString &id, QString color){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    it->setColor(color);
    QModelIndex ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{ColorRole});
}

void DroneListModel::setVisibility(const QString & id,bool visibility){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    it->setVisible(visibility);
    QModelIndex ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{VisibleRole});
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
        else if(role == TrackingRole)
            return it.trackingHistory();
        else if(role == HistoryRole)
            return it.getHistory();
        else if(role == FollowRole)
            return it.following();
        else if(role == AnimationStateRole)
            return it.extrapolating();
        else if(role == InfoRole)
            return it.getInfoList();
        else if(role == InfoNamesRole)
            return it.getInfoNames();
        else if(role == VisibleRole)
            return it.visibility();
    }
    return QVariant();
}

QHash<int, QByteArray> DroneListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "idInfo";
    roles[PosRole] = "posInfo";
    roles[AngleRole] = "angleInfo";
    roles[ColorRole] = "colorInfo";
    roles[TrackingRole] = "trackingHistoryInfo";
    roles[HistoryRole] = "historyInfo";
    roles[FollowRole] = "followInfo";
    roles[AnimationStateRole] = "extrapolateInfo";
    roles[InfoRole] = "infoInfo";
    roles[InfoNamesRole] = "infoNamesInfo";
    roles[VisibleRole] = "visibleInfo";
    return roles;
}

bool DroneListModel::setData(const QModelIndex &index, const QVariant &value,
                             int role) {
    if (!index.isValid())
        return false;
    if (index.row() >= 0 && index.row() < rowCount()) {
        if (role == PosRole) {
            const Data &data = value.value<Data>();
            mDrones[index.row()].setPos(data.coord);
            mDrones[index.row()].setAngle(data.angle);
            mDrones[index.row()].setInfos(data.infos);
            mDrones[index.row()].setInfoNames(data.infoNames);
            mDrones[index.row()].setExtrapolate(false);
            emit dataChanged(index, index, QVector<int>{PosRole,AngleRole,AnimationStateRole,InfoRole,InfoNamesRole,HistoryRole});
            mDrones[index.row()].setExtrapolate(true);
            emit dataChanged(index, index, QVector<int>{AnimationStateRole});
            return true;
        }
    }
    return false;
}

