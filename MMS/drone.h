#ifndef DRONE_H
#define DRONE_H

#include <QColor>
#include <QGeoCoordinate>
#include <iostream>
#include <QQmlContext>

class Drone
{
public:
    //Drone();
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

    double getAngle() const{
        return mAngle;
    }
    void setAngle(double angle){
        mAngle = angle;

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

    void setInfos(QVariantList infos){
        mInfos = infos;
    }

    QVariantList getInfoList() const{
        return mInfos;
    }

    void setInfoNames(QVariantList infoNames){
        mInfoNames = infoNames;
    }

    QVariantList getInfoNames() const{
        return mInfoNames;
    }

    QVariantList getSelectedInfoList() const{
        return selectedInfos;
    }

    void addSelectedInfo(QString key){
        if (selectedInfos.indexOf(key) == -1) selectedInfos.append(key);
    }

    void removeSelectedInfo(QString key){
        if (selectedInfos.indexOf(key) != -1) selectedInfos.removeOne(key);
    }

private:
    QString mId;
    QGeoCoordinate mPos;
    QList<QGeoCoordinate> history;
    QString mColor;
    double mAngle;
    QVariantList mInfos;
    QVariantList mInfoNames;
    QVariantList selectedInfos;

    bool follow=false;
    bool trackHistory=false;
    bool extrapolate = false;
    bool mVisible = true;

};



#endif // DRONE_H
