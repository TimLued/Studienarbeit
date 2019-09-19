#include "tasksender.h"
#include <QtNetwork>
#include <iostream>

TaskSender::TaskSender(QObject *parent):
    QObject (parent)
{
    server = new QLocalServer(this);
    connect(server, &QLocalServer::newConnection, this, &TaskSender::sendTask);
    server->listen("drone_task");
}

void TaskSender::appendTask(QString taskInfo)
{
    m_task.append(taskInfo);
}

bool TaskSender::sendTask()
{
    try {
        if(m_task.count()==0){
            QLocalSocket *clientConnection = server->nextPendingConnection();
            clientConnection->disconnectFromServer();
            return false;
         }

        QByteArray block;
        QDataStream out(&block, QIODevice::WriteOnly);
        out << quint32(m_task.size());
        out << m_task.first();
        m_task.removeFirst();

        QLocalSocket *clientConnection = server->nextPendingConnection();
        connect(clientConnection, QOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::error),this, &TaskSender::serverError);
        connect(clientConnection, &QLocalSocket::disconnected, clientConnection, &QLocalSocket:: deleteLater);
        clientConnection->write(block);
        clientConnection->flush();
        clientConnection->disconnectFromServer();
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
    }
    return true;
}

void TaskSender::serverError()
{
    std::cout << server->errorString().toUtf8().constData() << std::endl;
}


