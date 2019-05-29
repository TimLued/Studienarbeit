#include "posupdater.h"
#include <QGeoPositionInfo>
#include <QGeoCoordinate>
#include <QtCore>

#include <QThread>
#include <qtconcurrentrun.h>

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
    socket->abort();
    socket->connectToServer("dronespos");
    timer->stop();
    //keep on connecting

    if (!socket->waitForConnected(3000) || socket->state() == QAbstractSocket::UnconnectedState){
        //connection failed
        //std::cout << "recon" <<std::endl;
        timer->start(500);
    }
}

void PosUpdater::readPos()
{

    if (blockSize == 0) {
        // Relies on the fact that QDataStream serializes a quint32 into
        // sizeof(quint32) bytes
        if (socket->bytesAvailable() < (int)sizeof(quint32))
            return;
        in >> blockSize;
    }
    if (socket->bytesAvailable() < blockSize || in.atEnd())
        return;

    QString newPos;
    in >> newPos;

    if (newPos == "-") return;

    //std::cout << newPos.toUtf8().constData() <<std::endl;

    //update drone if new timestamp
    QList<QString> data = newPos.split(QRegExp("\\s+"),QString::SkipEmptyParts);

    if (data.count() == 4){
        QDateTime timestamp = QDateTime::fromString(QString(data.value(1)), Qt::ISODate);
        QGeoCoordinate cor;
        cor.setLatitude(data[2].toDouble());
        cor.setLongitude(data.value(3).toDouble());
        emit posUpdated(data[0],cor,timestamp);
    }

}
