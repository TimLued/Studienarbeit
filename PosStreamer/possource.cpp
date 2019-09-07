#include "possource.h"
#include <QtCore>
#include <QJsonDocument>
#include <iostream>

PosSource::PosSource(QObject *parent):
    QObject (parent),
    uavTimer(new QTimer(this))
{
    currentIndex = 0;
    running = false;
    uavTimer->setInterval(1);
    connect(uavTimer, SIGNAL(timeout()),this,SLOT(uavTick()));

}


void PosSource::loadFile(QString file){
    QFile logFile;
    logFile.setFileName(file);
    logFile.open(QIODevice::ReadOnly);

    QString val = logFile.readAll();
    logFile.close();

    QJsonDocument jsonResponse = QJsonDocument::fromJson(val.toUtf8());
    QJsonObject jsonObject = jsonResponse.object();
    QJsonArray jsonArray = jsonObject["drone"].toArray();

    foreach (const QJsonValue & value, jsonArray) {
        QJsonObject obj = value.toObject();
        QJsonDocument doc(obj);
        QString strJson(doc.toJson((QJsonDocument::Compact)));
        droneInfo.append(strJson);
    };
}

void PosSource::uavTick()
{
    QJsonObject jDroneInfo = QJsonDocument::fromJson(droneInfo[currentIndex].toUtf8()).object();
    if(currentIndex > 0){
        QDateTime tStamp = QDateTime::fromString(jDroneInfo["timestamp"].toString(),Qt::ISODate);
        int timediff = currentTimeStamp.time().msecsTo(tStamp.time());
        if(timediff > 0) uavTimer->setInterval(timediff);
        currentTimeStamp = tStamp;
    }

    emit posUpdated(droneInfo[currentIndex]);
    if (currentIndex<droneInfo.count()-1){ currentIndex+=1;}else{currentIndex=0;}
}

void PosSource::startStop(bool start,bool load){
    if (load && running){
        //load whole json ones
        foreach (const QString jLine, droneInfo){
            emit posUpdated(jLine);
        }
    }else{
        if (start&&running){
            uavTimer->start();
        }else{
            uavTimer->stop();
        }
    }
}

void PosSource::setRunning(bool status){
    running = status;
}




