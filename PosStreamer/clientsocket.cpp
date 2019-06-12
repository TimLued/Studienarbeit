#include "clientsocket.h"

#include <QtNetwork>
#include <qlocalserver.h>
#include <qlocalsocket.h>

#include <possource.h>

#include <iostream>
#include <QtCore>

ClientSocket::ClientSocket(QObject *parent):
    QObject (parent)
{
    //Local Server
    server = new QLocalServer(this);
    connect(server, &QLocalServer::newConnection, this, &ClientSocket::nextPos);
}

void ClientSocket::startServer(){
    server->listen("dronespos");
}

void ClientSocket::loadToBuffer(QString lastInfo){
    buffer.append(lastInfo);
    emit updateBuffer(buffer.count()); //Buffer Label update
}

void ClientSocket::resetBuffer(){
     buffer.clear();
     emit updateBuffer(buffer.count()); //Buffer Label update
     emit clearList();
}

void ClientSocket::nextPos()
{
    try {


    emit updateStatus(); //connected

    QString line;
    if (!buffer.isEmpty()){
        line = buffer.last();
        buffer.removeLast();
        emit updateBuffer(buffer.count());
        //emit updateList(line.trimmed());
    }else{
         line="-";
    }

    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out << quint32(line.size());
    out << line;

    QLocalSocket *clientConnection = server->nextPendingConnection();
    connect(clientConnection, QOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::error),this, &ClientSocket::serverError);
    connect(clientConnection, &QLocalSocket::disconnected, clientConnection, &QLocalSocket:: deleteLater);
    clientConnection->write(block);
    clientConnection->flush();
    clientConnection->disconnectFromServer();


    } catch (const std::exception& ex) {
         std::cerr << "Error: " << ex.what() << std::endl;
    }

}

void ClientSocket::serverError()
{
    std::cout << server->errorString().toUtf8().constData() << std::endl;
}
