#include "tasksender.h"
#include <QtNetwork>
#include <iostream>

TaskSender::TaskSender(QObject *parent):
    QObject (parent),
    server(new QLocalServer(this))
{
    connect(server, &QLocalServer::newConnection, this, &TaskSender::sendTask); //LEADS TO ERROR!!!
    server->listen("dronestask");
}

void TaskSender::appendTask(QString taskInfo)
{
    QJsonDocument jsonResponse = QJsonDocument::fromJson(taskInfo.toUtf8());
    QJsonObject jsonObject = jsonResponse.object();
    QJsonArray jsonArray = jsonObject["drone"].toArray();
    foreach (const QJsonValue & value, jsonArray) {
        QJsonObject obj = value.toObject();
        QJsonDocument doc(obj);
        QString strJson(doc.toJson((QJsonDocument::Compact)));
        m_task.append(strJson);
    }
}

bool TaskSender::sendTask()
{
    try{
        if(m_task.length()==0){
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

    } catch (...) {
        //sendTask();
    }
    return true;
}

void TaskSender::serverError()
{
    std::cout << server->errorString().toUtf8().constData() << std::endl;
}
