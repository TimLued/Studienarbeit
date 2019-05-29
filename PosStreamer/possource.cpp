#include "possource.h"
#include <QtCore>

#include <iostream>

PosSource::PosSource(QObject *parent):
    QObject (parent),
    logFile(new QFile(this)),
    timer(new QTimer(this))
{
    running = false;
    timer->setInterval(20); //interval == gps frequency
    connect(timer, SIGNAL(timeout()),this,SLOT(readNextPos()));
}

void PosSource::setupSource(QString file,int i){
    index = i;
    logFile->setFileName(file);
    logFile->open(QIODevice::ReadOnly);
}

void PosSource::readNextPos(){
    try {
        lastInfo = logFile->readLine();
        emit posUpdated(lastInfo);
        if (logFile->atEnd()) logFile->seek(0);
    } catch (const std::exception& ex) {
         std::cerr << "Error: " << ex.what() << std::endl;
    }

}

void PosSource::startStop(bool start){
    if (start){
        if (running) timer->start();
    }else{
        timer->stop();
    }
}

void PosSource::setRunning(bool status,int i){
    if (i==index) running = status;
}
