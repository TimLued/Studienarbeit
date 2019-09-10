#ifndef DRONE_H
#define DRONE_H

#include <QColor>
#include <QGeoCoordinate>
#include <iostream>
#include <QQmlContext>
#include <QDateTime>

class Drone
{
public:
    QString id() const{
        return mId;
    }
    void sedId(const QString &id){
        mId = id;
    }

    QGeoCoordinate pos() const{
        return mPos;
    }
    void setPos(const QGeoCoordinate &pos){
        if(mPos.isValid()) appendHistory(mPos);
        mPos = pos;
    }

    void appendHistory(const QGeoCoordinate &value){
        history<<value;
    }

    QVariantList getHistory() const{
        QVariantList history_list;
        for (const QGeoCoordinate &coord : history) {
          history_list << QVariant::fromValue(coord);
        }
        history_list << QVariant::fromValue(mPos);
        return history_list;
    }

    void appendRoute (QVariant waypoint){
        mRoute << waypoint;
    }

    void resetRoute (){
        mRoute.clear();
        mRoutePath.clear();
    }

    QVariantList getRoute() const{
        return mRoute;
    }

    void appendRoutePath (const QGeoCoordinate &waypoint){
        mRoutePath << waypoint;
    }

    QVariantList getRoutePath() const{
        QVariantList route_list;
        for (const QGeoCoordinate &coord : mRoutePath) {
          route_list << QVariant::fromValue(coord);
        }
        return route_list;
    }

    QList<QGeoCoordinate> getRoutePathInCoordinates() const{
        return mRoutePath;
    }


    QString getColor() const{
        return mColor;
    }

    void setColor(QString color){
        mColor = color;
    }

    void setFollow(){
        follow = !follow;
    }

    bool following() const{
        return follow;
    }

    void setTrackHistory(){
        trackHistory = !trackHistory;
    }

    bool trackingHistory() const{
        return trackHistory;
    }

    void setShowRoute(){
        showRoute = !showRoute;
    }

    bool showingRoute() const{
        return showRoute;
    }

    void setLeg(QList<QGeoCoordinate> leg){
        mHotLeg = leg;
    }

    QVariantList getLeg() const{
        QVariantList leg_list;
        for (const QGeoCoordinate &coord : mHotLeg) {
          leg_list << QVariant::fromValue(coord);
        }
        return leg_list;
    }

    int getLastLeg() const{
        return lastLegIndex;
    }

    void setLastLeg(int i){
        lastLegIndex = i;
    }


    double getAngle() const{
        return mAngle;
    }
    void setAngle(double angle){
        mAngle = angle;
    }

    double getSpeed() const{
        return mSpeed;
    }
    void setSpeed(double speed){
        mSpeed = speed;
    }

    QDateTime getTimeStamp() const{
        return mTimeStamp;
    }
    void setTimeStamp(QDateTime ts){
        mTimeStamp = ts;
    }

    bool extrapolating() const{
        return extrapolate;
    }
    void setExtrapolate(bool status){
        extrapolate = status;
    }

    bool visibility() const{
        return mVisible;
    }

    void setVisible(bool visibility){
        mVisible = visibility;
    }

    //all info names and values (only change on updates)
    void setInfoNames(QVariantList infoNames){
        mInfoNames = infoNames;
    }

    QVariantList getInfoNames() const{
        return mInfoNames;
    }

    void setInfoValues(QVariantList infoValues){
        mInfoValues = infoValues;
        for (int i = 0;i<mSelectedInfoNames.count();i++) {

            int index = mInfoNames.indexOf(mSelectedInfoNames[i]);

            if (index == -1){
                break;
            }else{
                mSelectedInfoValues[i] = mInfoValues[index];
            }

        }
    }

    QVariantList getInfoValues() const{
        return mInfoValues;
    }

    //Selected is to display
    bool addSelectedInfoNames(QString name){
        if (mSelectedInfoNames.indexOf(name) != -1) return false;
        mSelectedInfoNames.append(name);
        return true;
    }

    void removeSelectedInfoNames(QString name){
        if (mSelectedInfoNames.indexOf(name) != -1) mSelectedInfoNames.removeOne(name);
    }

    QVariantList getSelectedInfoNames() const{
        return mSelectedInfoNames;
    }

    void addSelectedInfoValues(QString value){
        mSelectedInfoValues.append(value);
    }

    void removeSelectedInfoValues(int index){
        mSelectedInfoValues.removeAt(index);
    }

    QVariantList getSelectedInfoValues() const{
        return mSelectedInfoValues;
    }

    QString group() const{
        return mGroup;
    }

    void setGroup(QString group){
        mGroup = group;
    }



private:
    QString mId;
    QGeoCoordinate mPos;
    QList<QGeoCoordinate> history;
    QString mColor;
    double mAngle;
    double mSpeed;
    QDateTime mTimeStamp;
    QVariantList mInfos;
    QVariantList mInfoNames;
    QVariantList mInfoValues;
    QVariantList mSelectedInfoNames;
    QVariantList mSelectedInfoValues;
    QVariantList mRoute;
    QList<QGeoCoordinate> mRoutePath;
    QList<QGeoCoordinate> mHotLeg;
    int lastLegIndex = 0;
    QString mGroup;

    bool follow=false;
    bool trackHistory=false;
    bool showRoute=false;
    bool extrapolate = false;
    bool mVisible = true;

};



#endif // DRONE_H
