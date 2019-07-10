#include "transsmoother.h"
#include <QtCore>

#include <QGeoCoordinate>
#include <QGeoLocation>

#include <iostream>
#include <iomanip>

TransSmoother::TransSmoother(QObject *parent):
    QObject (parent),
    timer(new QTimer(this))
{
    connect(timer, SIGNAL(timeout()), this, SLOT(timeTrigger()));
}

void TransSmoother::start(int interval, double dist, double bearing, QGeoCoordinate lastCor){ //speed, bearing
    mInterval = interval;
    mDist = dist;
    mBearing = bearing;
    cor = lastCor;
    timer->start(1);
}

void TransSmoother::stop(){
    timer->stop();
}

void TransSmoother::timeTrigger(){
    timer->setInterval(mInterval);
    cor = cor.atDistanceAndAzimuth(mDist,mBearing);
    emit posUpdate(cor);
}
