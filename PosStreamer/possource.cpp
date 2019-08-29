#include "possource.h"
#include <QtCore>
#include <QJsonDocument>
#include <iostream>

PosSource::PosSource(QObject *parent):
    QObject (parent),
    timer(new QTimer(this))
{
    running = false;
    timer->setInterval(20); //interval == gps frequency
    connect(timer, SIGNAL(timeout()),this,SLOT(readNextPos()));
}

void PosSource::setupSource(QString file,int i){
    lvIndex = i;
    currentInfoIndex = 0;

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
    }
}

//JSON
void PosSource::readNextPos(){
    emit posUpdated(droneInfo[currentInfoIndex]);
    if (currentInfoIndex<droneInfo.count()-1){ currentInfoIndex+=1;}else{currentInfoIndex=0;}

}

void PosSource::startStop(bool start,bool load){
    if (load && running){
        //load whole json ones
        foreach (const QString jLine, droneInfo){
            emit posUpdated(jLine);
        }
    }else{
        if (start&&running){
            timer->start();
        }else{
            timer->stop();
        }
    }

}

void PosSource::setRunning(bool status,int i){
    if (i==lvIndex) running = status;
}


