#include <dronelistmodel.h>
#include <QGeoCoordinate>
#include <QJsonDocument>
#include <QJsonObject>
#include <cmath>
#include <QDateTime>
#include <iostream>
#include <QString>

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


    if(it != mDrones.end()){
        //save all data
        QVariantList infoNames = it -> getInfoNames(); //load old list (so if later value is not updated)
        QVariantList infoValues = it -> getInfoValues();

        QRegExp re("[+-]?\\d*\\.?\\d+");

        foreach(const QString& key, jDroneInfo.keys()) {

            QString val = jDroneInfo.value(key).toString();
            if (re.exactMatch(val)) val = QString::number(val.toDouble(),'f',2); //round if info is numerical

            if (!infoNames.contains(key)) {//no double allowed
                infoNames << key;
                if(key=="altitude") val+=" -";
                infoValues << val;
            }else{//Update value

                if(key.toLower()=="altitude"){


                    double oVal  = infoValues[infoNames.indexOf(key)].toString().split(" ")[0].toDouble();
                    double diff = std::abs(val.toDouble()-oVal);

                    val+= diff<0.01? " -" : (val.toDouble()-oVal>0? " \u2227":" \u2228");

                };
                infoValues[infoNames.indexOf(key)] = val;
            }

        }

        QModelIndex ix = index(it - mDrones.begin());

        //hot leg
        QVariantList wpList = it->getRoutePath();


        if (wpList.length()>2){


            //distance to wp getting smaller
            QList<QPair<int,double>> distCandidates={};

            int lastLeg = it->getLastLeg();

            //QGeoCoordinate oldPos = it->getHistory()[histLength-2].value<QGeoCoordinate>();
            QGeoCoordinate oldPos = it->pos();
            QGeoCoordinate nPos = coord;
            double oldDist,newDist;
            for (int j=0;j<wpList.length();j++){
                oldDist = oldPos.distanceTo(wpList[j].value<QGeoCoordinate>());
                newDist = nPos.distanceTo(wpList[j].value<QGeoCoordinate>());
                if(newDist-oldDist<0.){
                    distCandidates.append(qMakePair(j,newDist));
                    if(j==lastLeg+1) break;
                }
            }

            //            if(distCandidates.count()>0){
            //                QList<QPair<int,double>>courseCandidates = {};

            //                for(int i=0;i<distCandidates.count();i++){
            //                    int index = distCandidates[i].first;
            //                    if(index!=0){
            //                        double courseWpWp = wpList[index-1].value<QGeoCoordinate>().azimuthTo(wpList[index].value<QGeoCoordinate>());
            //                        double droneToLastWp = it->pos().distanceTo(wpList[index-1].value<QGeoCoordinate>());
            //                        double droneCourse = it->pos().atDistanceAndAzimuth(-droneToLastWp,angle).azimuthTo(wpList[index].value<QGeoCoordinate>());
            //                        if(abs(droneCourse-courseWpWp)<45) courseCandidates.append(qMakePair(index,distCandidates[i].second));
            //                    }
            //                }


            //get closest or next in chain
            if(distCandidates.count()>0){
                int indexOfDist = 0;
                double smallestDist=0.;
                if(distCandidates.last().first == lastLeg+1){//is next hot leg
                    smallestDist = distCandidates.last().second;
                    indexOfDist = distCandidates.last().first;
                }else {
                    for(int k=0;k<distCandidates.count();k++){
                        if(smallestDist==0.||smallestDist-distCandidates[k].second>0){
                            smallestDist = distCandidates[k].second;
                            indexOfDist = distCandidates[k].first;
                        }
                    }
                }
                if(smallestDist<200 && indexOfDist+1<wpList.length()){//next leg
                    it->setLeg({wpList[indexOfDist].value<QGeoCoordinate>(),wpList[indexOfDist+1].value<QGeoCoordinate>()},indexOfDist);
                    it->setDisplayedLeg(indexOfDist+1);
                }else if(smallestDist>=200&&indexOfDist>0){
                    it->setLeg({wpList[indexOfDist-1].value<QGeoCoordinate>(),wpList[indexOfDist].value<QGeoCoordinate>()},indexOfDist-1);
                    it->setDisplayedLeg(indexOfDist);
                }else if(wpList[0]==wpList.last()){
                    if(nPos.distanceTo(wpList[0].value<QGeoCoordinate>())<200){
                        it->setLeg({wpList[0].value<QGeoCoordinate>(),wpList[1].value<QGeoCoordinate>()},0);
                        it->setDisplayedLeg(1);
                    }else{
                        it->setLeg({wpList[wpList.count()-2].value<QGeoCoordinate>(),wpList.last().value<QGeoCoordinate>()},wpList.count()-2);
                        it->setDisplayedLeg(wpList.count()-2);
                    }

                }else{
                    it->setLeg({},-1);
                    it->setDisplayedLeg(-1);
                }
                //                }else{
                //                    it->setLeg({},-1);
                //                    it->setDisplayedLeg(-1);
                //                }
            }else{
                it->setLeg({},-1);
                it->setDisplayedLeg(-1);
            }
        }else{
            it->setLeg({},-1);
            it->setDisplayedLeg(-1);
        }


        emit dataChanged(ix, ix, QVector<int>{HotLegRole});


        //speed
        double distance = it->pos().distanceTo(coord);
        double time =it->getTimeStamp().time().msecsTo(timestamp.time());
        double speed = distance / time * 1000;
        if (speed < 0) speed = it->getSpeed();
        QString mSpeed = QString::number(speed,'f',2);

        if (!infoNames.contains("speed")) {//save to infos
            infoNames << "speed";
            infoValues << mSpeed;
        }else{//Update value
            infoValues[infoNames.indexOf("speed")] = mSpeed;
        }
        if (!infoNames.contains("Hot Leg")){
            infoNames << "Hot Leg";
            infoValues << (it->getLegIndex()!=-1?it->getLeg().value<Waypoint>().id:"-");
        }else{//update
            infoValues[infoNames.indexOf("Hot Leg")]= it->getLegIndex()!=-1?it->getLeg().value<Waypoint>().id:"-";
        }
        if (!infoNames.contains("ALL")){
            infoNames << "ALL";
            infoValues << "ALL";
        }

        Data data{coord, angle, speed,timestamp, infoNames,infoValues};
        return setData(ix, QVariant::fromValue(data), PosRole);
    }else{
        //create
        return createDrone(id);
    }
}

bool DroneListModel::updateTasks(const QString &jInfo)
{
    // loading missions & waypoints
    QJsonObject jDroneInfo = QJsonDocument::fromJson(jInfo.toUtf8()).object();
    QString id = jDroneInfo["id"].toString();
    QGeoCoordinate coord = QGeoCoordinate(jDroneInfo["lat"].toString().toDouble(),jDroneInfo["lon"].toString().toDouble());

    if(jDroneInfo.keys().contains("drone")){
        auto it_task = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
                return obj.id() == jDroneInfo["drone"].toString();});
    QModelIndex ix = index(it_task - mDrones.begin());

    if(jDroneInfo.keys().contains("mission")){

        Task task{id,
                    jDroneInfo["mission"].toString(),
                    jDroneInfo["geoType"].toString(),
                    jDroneInfo["taskType"].toString(),
                    coord};
        if(jDroneInfo.keys().contains("reset")){
            it_task->clearMissions();
            it_task->setChangeNote("Auftragsänderung für " + it_task->id());
            emit dataChanged(ix, ix, QVector<int>{changeNoteRole});
        }
        if(!(jDroneInfo.keys().contains("reset")&&jDroneInfo["mission"].toString()=="")) it_task->appendTask(task);

    }else{
        Waypoint wp{jDroneInfo["id"].toString(),jDroneInfo["lat"].toString(),jDroneInfo["lon"].toString()};
        if(it_task != mDrones.end()){

            if(jDroneInfo.keys().contains("reset")) {
                it_task->setLeg({},-1);
                it_task->setDisplayedLeg(-1);
                it_task->resetRoute();//delete old data
                it_task->setChangeNote("Flugplanupdate für " + it_task->id());
                emit dataChanged(ix, ix, QVector<int>{changeNoteRole});
            }
            it_task->appendRoute(QVariant::fromValue(wp));
            it_task->appendRoutePath(coord);

        }else{//should occur just once per drone
            createDrone(jDroneInfo["drone"].toString());
            mDrones.last().appendRoute(QVariant::fromValue(wp));
            mDrones.last().appendRoutePath(coord);
        }

        emit dataChanged(ix, ix, QVector<int>{WaypointRole,RouteRole});
    }

}
return true;
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
    it.setChangeNote("Hinweis: Neue UAV " + id);
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


    QList<QVariant> infos;
    if(info=="ALL"){
        infos=it->getInfoNames();
    }else infos.append(info);

    foreach(QVariant data,infos){
        if(data.toString()!="ALL"&&it->addSelectedInfoNames(data.toString())){
            int index = it->getInfoNames().indexOf(data.toString());
            QString val = it->getInfoValues().value(index).toString();
            it->addSelectedInfoValues(val);
        }
    }

    emit dataChanged(ix, ix, QVector<int>{InfoSelectedNamesRole,InfoSelectedValuesRole});


    //    if(!it->addSelectedInfoNames(info)) return false;
    //    int index = it->getInfoNames().indexOf(info);
    //    QString val = it->getInfoValues().value(index).toString();
    //    it->addSelectedInfoValues(val);
    //    emit dataChanged(ix, ix, QVector<int>{InfoSelectedNamesRole,InfoSelectedValuesRole});

    return true;
}

bool DroneListModel::setUnselectedInfoList(const QString&id,QString info){
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){
            return obj.id() == id;});
    QModelIndex ix = index(it - mDrones.begin());


    if(info=="ALL"){
        int n = it->getSelectedInfoNames().length();
        for(int i=0;i<n;i++){
            it->removeSelectedInfoNames(it->getSelectedInfoNames()[0].toString());
            it->removeSelectedInfoValues(0);
        }

    }else{
        int index = it->getSelectedInfoNames().indexOf(info);
        if(index == -1) return false;
        it->removeSelectedInfoNames(info);
        it->removeSelectedInfoValues(index);
    }


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

void DroneListModel::setHistoryRange(const QString &id, int start, int end)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    it->setHistoryRange(start,end);
    QModelIndex ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{HistoryRangeRole});
}

void DroneListModel::switchMarked(const QString &id)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    it->setMarked();
    QModelIndex ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{markListRole});
    it->setMarked();//for next call
    emit dataChanged(ix, ix, QVector<int>{markListRole});
}

QVariant DroneListModel::getTasks(const QString &id)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    return it->getTasks();
}

void DroneListModel::setLeg(const QString &id, int i,QGeoCoordinate from, QGeoCoordinate to)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    if (i==-1){
        it->setLeg({},i);
    }else {
        it->setLeg({from,to},i);
    }

    QModelIndex ix = index(it - mDrones.begin());
    emit dataChanged(ix, ix, QVector<int>{HotLegRole});
}

void DroneListModel::setDisplayedLeg(const QString &id, int i)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    it->setDisplayedLeg(i);
}

int DroneListModel::getLastLeg(const QString &id)
{
    auto it = std::find_if(mDrones.begin(), mDrones.end(), [&](Drone const& obj){return obj.id() == id;});
    return it->getLastLeg();
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
            return it.getLegCoordinates();
        case SpeedRole:
            return it.getSpeed();
        case GroupRole:
            return it.group();
        case TimestampsRole:
            return it.getTimestamps();
        case HistoryRangeRole:
            return it.getHistoryRange();
        case ShortHistoryRole:
            return it.getShortHistory();
        case changeNoteRole:
            return it.getChangeNote();
        case markListRole:
            return it.marked();
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
    roles[TimestampsRole] = "timestampsInfo";
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
    roles[HistoryRangeRole] = "rangeInfo";
    roles[ShortHistoryRole] = "shortHistoryInfo";
    roles[changeNoteRole] = "noteInfo";
    roles[markListRole] = "markInfo";
    return roles;
}

bool DroneListModel::setData(const QModelIndex &index, const QVariant &value,int role) {
    if (!index.isValid())
        return false;
    if (index.row() >= 0 && index.row() < rowCount()) {
        if (role == PosRole) {
            const Data &data = value.value<Data>();
            mDrones[index.row()].setPos(data.coord,data.timestamp);
            mDrones[index.row()].setAngle(data.angle);
            mDrones[index.row()].setSpeed(data.speed);
            mDrones[index.row()].setTimeStamp(data.timestamp);
            mDrones[index.row()].setInfoNames(data.infoNames);
            mDrones[index.row()].setInfoValues(data.infoValues);
            mDrones[index.row()].setExtrapolate(false);
            emit dataChanged(index, index, QVector<int>{PosRole,AngleRole,SpeedRole,AnimationStateRole,HistoryRole,InfoNamesRole,InfoSelectedValuesRole,TimestampsRole});
            mDrones[index.row()].setExtrapolate(true);
            emit dataChanged(index, index, QVector<int>{AnimationStateRole});
            return true;
        }
    }
    return false;
}


