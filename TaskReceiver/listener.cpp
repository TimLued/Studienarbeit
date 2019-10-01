#include "listener.h"
#include <QtCore>
#include <QThread>
#include <iostream>

Listener::Listener(QObject *parent):
    QObject (parent),
    socket(new QLocalSocket(this)),
    timer(new QTimer(this))
{
    in.setDevice(socket);
    in.setVersion(QDataStream::Qt_5_10);
    connect(socket, &QLocalSocket::readyRead, this, &Listener::readTask);
    connect(socket, &QLocalSocket::disconnected,this,&Listener::requestTask);
    connect(timer, SIGNAL(timeout()), this, SLOT(recon()));
    requestTask();
}

void Listener::requestTask(){
    timer->start(2);
}

void Listener::recon(){
    blockSize = 0;
    try {
        socket->abort();
        socket->connectToServer("drone_task");
        timer->stop();
        //keep on connecting

        if (!socket->waitForConnected(3000) || socket->state() != QAbstractSocket::ConnectedState){
            timer->start(200);
        }
    } catch (...) {
        recon();
    }
}

void Listener::readTask(){
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

        emit taskReceived(newData);
    } catch (...) {
    }
}
