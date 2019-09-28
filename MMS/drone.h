#ifndef DRONE_H
#define DRONE_H

#include <QColor>
#include <QGeoCoordinate>
#include <iostream>
#include <QQmlContext>
#include <QDateTime>
#include <QStringList>
typedef QPair<int,int> RangeType;

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
    void setPos(const QGeoCoordinate &pos,QDateTime stamp){
        if(mPos.isValid()){
            appendHistory(mPos);
            timestamps<<stamp;
        }
        mPos = pos;
    }

    void appendHistory(const QGeoCoordinate &value){
        history<<value;
    }

    QVariantList getHistory() const{
        QVariantList history_list;
        for (int i=historyRange.first;i<(historyRange.second==-2?history.length():historyRange.second+1);i++){
          history_list << QVariant::fromValue(history[i]);
        }
        return history_list;
    }

    QVariantList getTimestamps() const{
        QVariantList timestamp_list;
        for (const QDateTime &stamp : timestamps) {
          timestamp_list << QVariant::fromValue(stamp);
        }
        //timestamp_list << QVariant::fromValue(mTimeStamp);
        return timestamp_list;
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

    void setLeg(QList<QGeoCoordinate> leg,int index){
        mHotLeg = leg;
        mHotLegIndex = index;
    }

    int getLegIndex() const{
        return mHotLegIndex;
    }

    QVariant getLeg() const{
        return mRoute[mHotLegIndex];
    }

    QVariantList getLegCoordinates() const{
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

    QVariantList getHistoryRange() const{
        QVariantList range_list;
        range_list<<historyRange.first;
        range_list<<historyRange.second;
        return  range_list;

    }

    void setHistoryRange(int start,int end){
        int newStart = start==-1?historyRange.first:start;
        int newEnd = end==-1?historyRange.second:end;
        RangeType newRange(newStart,newEnd);
        historyRange = newRange;
    }

    QVariantList getShortHistory() const{
        return mShortHistroy;
    }

    void setShortHistory(QVariantList shortHistory){
        mShortHistroy= shortHistory;
    }

    void setChangeNote(QString note){
        changeNote<<note;
    }

    QString getChangeNote() const{
        return QString::number(changeNote.count()-1) +":" + changeNote.last();
    }

    bool marked() const{
        return markInList;
    }

    void setMarked(){
        markInList = !markInList;
    }


private:
    QString mId;
    QGeoCoordinate mPos;
    QList<QGeoCoordinate> history;
    QList<QDateTime> timestamps;
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
    int mHotLegIndex = -1;
    int lastLegIndex = -1;
    QString mGroup;
    RangeType historyRange = qMakePair(0,-2);
    QVariantList mShortHistroy;
    QList<QString> changeNote;

    bool follow=false;
    bool trackHistory=false;
    bool showRoute=false;
    bool extrapolate = false;
    bool mVisible = true;
    bool markInList = false;

};



#endif // DRONE_H
