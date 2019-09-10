#include <dronelistmodel.h>
#include <QGeoCoordinate>
#include <QJsonDocument>
#include <QJsonObject>
#include <cmath>
#include <QDateTime>
#include <iostream>

DroneListModel::DroneListModel(QObject *parent):QAbstractListModel(parent) {}

void DroneListModel::register_object(const QString &droneId,QQmlContext *context){
    context->setContextProperty(droneId, this);
}

bool DroneListModel::updateDrone(const QString & jInfo){

    QJsonObject jDroneInfo = QJsonDocument::fromJson(jInfo.toUtf8()).object();
    QString id = jDroneInfo["id"].toString();
    QGeoCoordinate coord = QGeoCoordinate(jDroneInfo["lat"].toString().toDouble(),jDroneInfo["lon"].toString().toDouble());
    QDateTime timestamp = QDateTime::fromString(jDroneInfo["timestamp"].toString(),Qt::ISODate);

    double angle = jDroneInfo["bearing"].toString().toDouble();

    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});

    // loading waypoints
    if(jDroneInfo.keys().contains("drone")){
        auto it_wp = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
                return obj.id() == jDroneInfo["drone"].toString();});

        Waypoint wp{jDroneInfo["id"].toString(),jDroneInfo["lat"].toString(),jDroneInfo["lon"].toString()};
        if(it_wp != mDrones.end()){
            if(jDroneInfo.keys().contains("reset")) it_wp->resetRoute();
            it_wp->appendRoute(QVariant::fromValue(wp));
            it_wp->appendRoutePath(coord);
        }else{//should occur just once per drone
            createDrone(jDroneInfo["drone"].toString());
            mDrones.last().appendRoute(QVariant::fromValue(wp));
            mDrones.last().appendRoutePath(coord);
        }

        QModelIndex ix = index(it_wp - mDrones.begin());
        emit dataChanged(ix, ix, QVector<int>{WaypointRole,RouteRole});
        return true;
    }

    if(it != mDrones.end()){

        /*append
        DETERMINE bearing and speed from coordinates
        std::cout<<it->getHistory().last().value<QGeoCoordinate>().azimuthTo(coord)<<std::endl;
        50Hz updates
        std::cout<<coord.distanceTo(it->getHistory().last().value<QGeoCoordinate>())/0.02<<std::endl;
        */

        //save all data
        QVariantList infoNames = it -> getInfoNames(); //load old list (so if later value is not updated)
        QVariantList infoValues = it -> getInfoValues();

        QRegExp re("[+-]?\\d*\\.?\\d+");

        foreach(const QString& key, jDroneInfo.keys()) {
            QString val = jDroneInfo.value(key).toString();
            if (re.exactMatch(val)) val = QString::number(val.toDouble(),'f',2); //round if info is numerical

            if (!infoNames.contains(key)) {//no double allowed
                infoNames << key;
                infoValues << val;
            }else{//Update value
                infoValues[infoNames.indexOf(key)] = val;
            }
        }



        QModelIndex ix = index(it - mDrones.begin());

        //hot leg
        QList<QGeoCoordinate> wpList = it->getRoutePathInCoordinates();
        double bearCheck,wpAzi,projectedAzi,distToLastWp;
        if (wpList.length()>2){
            for(int i=(it->getLastLeg()!=-1?it->getLastLeg():0);i<wpList.length()-1;i++){

                wpAzi = wpList[i].azimuthTo(wpList[i+1]);
                distToLastWp = it->pos().distanceTo(wpList[i]);
                projectedAzi = it->pos().atDistanceAndAzimuth(-distToLastWp,angle).azimuthTo(wpList[i+1]);

                bearCheck = abs(wpAzi-projectedAzi);
                if (bearCheck<1&&(i+2)<wpList.length()){
                    if(it->pos().distanceTo(wpList[i+1])<200){
                        //next leg
                        it->setLeg({wpList[i+1],wpList[i+2]});
                        it->setLastLeg(i);
                    }else{
                        it->setLeg({wpList[i],wpList[i+1]});
                        it->setLastLeg(i);
                    }
                    break;
                }else if((bearCheck<1&&(i+1)<wpList.length())){
                    it->setLeg({wpList[i],wpList[i+1]});
                    it->setLastLeg(i);
                    break;
                }
                if(i==wpList.length()-2){
                    //no leg
                    it->setLeg({});
                    it->setLastLeg(-1);
                }
            }
        }else{it->setLeg({});}

        //speed
        double distance = it->pos().distanceTo(coord);
        double time =it->getTimeStamp().time().secsTo(timestamp.time());
        double speed = distance / time;
        if (speed < 0) speed = it->getSpeed();
        QString mSpeed = QString::number(speed,'f',2);

        if (!infoNames.contains("speed")) {//save to infos
            infoNames << "speed";
            infoValues << mSpeed;
        }else{//Update value
            infoValues[infoNames.indexOf("speed")] = mSpeed;
        }

        emit dataChanged(ix, ix, QVector<int>{HotLegRole});

        Data data{coord, angle, speed,timestamp, infoNames,infoValues};
        return setData(ix, QVariant::fromValue(data), PosRole);
    }else{
        //create
        return createDrone(id);
    }
}

bool DroneListModel::createDrone(const QString & id){
    beginInsertRows(QModelIndex(), rowCount(), rowCount());

    Drone it;
    it.sedId(id);
    //it.setPos(coord);
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

void DroneListModel::toggleShowingRoute(const QString &id){
    QModelIndex ix;
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});

    it->setShowRoute();

    ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{ShowingRouteRole});
}

//{For Generic List in DronePanel
QVariant DroneListModel::getInfoNameList(const QString&id){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    return it->getInfoNames();
}

bool DroneListModel::setSelectedInfoList(const QString&id,QString info){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    QModelIndex ix = index(it - mDrones.begin());


    //what if not in anymore?
    if(!it->addSelectedInfoNames(info)) return false;

    int index = it->getInfoNames().indexOf(info);
    QString val = it->getInfoValues().value(index).toString();
    it->addSelectedInfoValues(val);
    emit dataChanged(ix, ix, QVector<int>{InfoSelectedNamesRole,InfoSelectedValuesRole});

    return true;
}

bool DroneListModel::setUnselectedInfoList(const QString&id,QString info){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});   
    QModelIndex ix = index(it - mDrones.begin());

    int index = it->getSelectedInfoNames().indexOf(info);
    if(index == -1) return false;
    it->removeSelectedInfoNames(info);
    it->removeSelectedInfoValues(index);

    emit dataChanged(ix, ix, QVector<int>{InfoSelectedNamesRole,InfoSelectedValuesRole});

    return true;
}
//For Generic List in DronePanel}

//{For Center on all visible
QVariant DroneListModel::getAllDronePos(){
    QVariantList dronePos_list;
    for (const Drone &drone:mDrones){
        if(drone.visibility()&drone.pos().isValid()) dronePos_list<<QVariant::fromValue(drone.pos());
    }
    return dronePos_list;
}

QVariant DroneListModel::getDronePos(const QString&id){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    return QVariant::fromValue(it->pos());
}

QVariant DroneListModel::getRoute(const QString &id)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    return it->getRoutePath();
}

void DroneListModel::setGroup(const QString &id, QString group)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    it->setGroup(group);
    QModelIndex ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{GroupRole});
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

        switch (role) {
        case IdRole:
            return it.id();
        case PosRole:
            return QVariant::fromValue(it.pos());
        case ColorRole:
            return it.getColor();
        case AngleRole:
            return it.getAngle();
        case TrackingRole:
            return it.trackingHistory();
        case ShowingRouteRole:
             return it.showingRoute();
        case HistoryRole:
            return it.getHistory();
        case FollowRole:
            return it.following();
        case AnimationStateRole:
            return it.extrapolating();
        case InfoNamesRole:
            return it.getInfoNames();
        case InfoValuesRole:
            return it.getInfoValues();
        case InfoSelectedNamesRole:
            return it.getSelectedInfoNames();
        case InfoSelectedValuesRole:
            return it.getSelectedInfoValues();
        case VisibleRole:
            return it.visibility();
        case WaypointRole:
            return it.getRoute();
        case RouteRole:
            return it.getRoutePath();
        case HotLegRole:
            return it.getLeg();
        case SpeedRole:
            return it.getSpeed();
        case GroupRole:
            return it.group();
        default:
            break;
        }

    }
    return QVariant();
}

QHash<int, QByteArray> DroneListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    roles[IdRole] = "idInfo";
    roles[PosRole] = "posInfo";
    roles[AngleRole] = "angleInfo";
    roles[SpeedRole] = "speedInfo";
    roles[ColorRole] = "colorInfo";
    roles[TrackingRole] = "trackingHistoryInfo";
    roles[ShowingRouteRole] = "showingRouteInfo";
    roles[HistoryRole] = "historyInfo";
    roles[FollowRole] = "followInfo";
    roles[AnimationStateRole] = "extrapolateInfo";
    roles[InfoNamesRole] = "infoNamesInfo";
    roles[InfoValuesRole] = "infoValuesInfo";
    roles[InfoSelectedNamesRole] = "infoSelectedNamesInfo";
    roles[InfoSelectedValuesRole] = "infoSelectedValuesInfo";
    roles[VisibleRole] = "visibleInfo";
    roles[WaypointRole] = "wpInfo";
    roles[RouteRole] = "routeInfo";
    roles[HotLegRole] = "legInfo";
    roles[GroupRole] = "groupInfo";
    return roles;
}

bool DroneListModel::setData(const QModelIndex &index, const QVariant &value,int role) {
    if (!index.isValid())
        return false;
    if (index.row() >= 0 && index.row() < rowCount()) {
        if (role == PosRole) {
            const Data &data = value.value<Data>();
            mDrones[index.row()].setPos(data.coord);
            mDrones[index.row()].setAngle(data.angle);
            mDrones[index.row()].setSpeed(data.speed);
            mDrones[index.row()].setTimeStamp(data.timestamp);
            mDrones[index.row()].setInfoNames(data.infoNames);
            mDrones[index.row()].setInfoValues(data.infoValues);
            mDrones[index.row()].setExtrapolate(false);
            emit dataChanged(index, index, QVector<int>{PosRole,AngleRole,SpeedRole,AnimationStateRole,HistoryRole,InfoNamesRole,InfoSelectedValuesRole});
            mDrones[index.row()].setExtrapolate(true);
            emit dataChanged(index, index, QVector<int>{AnimationStateRole});
            return true;
        }
    }
    return false;
}


