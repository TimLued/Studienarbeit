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

    int getAngle() const{
        return mAngle;
    }
    void setAngle(int angle){
        mAngle = angle;
    }

private:
    QString mId;
    QGeoCoordinate mPos;
    QList<QGeoCoordinate> history;
    QString mColor;
    int mAngle;
    bool follow=false;

};



#endif // DRONE_H
