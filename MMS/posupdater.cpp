#include "posupdater.h"
#include <QtCore>
#include <iostream>

PosUpdater::PosUpdater(QObject *parent):
     QObject (parent),
     socket(new QLocalSocket(this)),
     timer(new QTimer(this))
{
    in.setDevice(socket);
    in.setVersion(QDataStream::Qt_5_10);
    connect(socket, &QLocalSocket::readyRead, this, &PosUpdater::readPos);
    connect(socket, &QLocalSocket::disconnected,this,&PosUpdater::requestPos);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
}

void PosUpdater::requestPos()
{
    timer->start(2);
}

void PosUpdater::update(){
    blockSize = 0;
    try {
        socket->abort();
        socket->connectToServer("dronespos");
        timer->stop();
        //keep on connecting

        if (!socket->waitForConnected(3000) || socket->state() != QAbstractSocket::ConnectedState){
            //connection failed
            timer->start(500);
        }
    } catch (...) {
    }
}

void PosUpdater::readPos()
{
    try {
        if (blockSize == 0) {
            // Relies on the fact that QDataStream serializes a quint32 into
            // sizeof(quint32) bytes
            if (socket->bytesAvailable() < (int)sizeof(quint32))
                return;
            in >> blockSize;
        }
        if (socket->bytesAvailable() < blockSize || in.atEnd())
            return;

        QString newData;
        in >> newData;

        emit posUpdated(newData);
    } catch (...) {
    }
}
