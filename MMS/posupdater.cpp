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
}

void PosUpdater::requestPos()
{
    timer->start(mInteverval);
}

void PosUpdater::update(){
    try {
        blockSize = 0;
        timer->stop();
        socket->abort();
        socket->connectToServer(tupeName);

        //keep on connecting

        if (!socket->waitForConnected(3000) || socket->state() != QLocalSocket::ConnectedState){
            timer->start(500);
        }
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
    }
}

void PosUpdater::setTupeName(QString mTupe,int interval)
{
    tupeName = mTupe;
    mInteverval = interval;
    connect(socket, &QLocalSocket::readyRead, this, &PosUpdater::readPos);
    connect(socket, &QLocalSocket::disconnected,this,&PosUpdater::requestPos);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
}

void PosUpdater::readPos()
{
    try {
        if (blockSize == 0) {
            if (socket->bytesAvailable() < (int)sizeof(quint32))
                return;
            in >> blockSize;
        }
        if (socket->bytesAvailable() < blockSize || in.atEnd())
            return;

        QString newData;
        in >> newData;

        emit posUpdated(newData);
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
    }
}
