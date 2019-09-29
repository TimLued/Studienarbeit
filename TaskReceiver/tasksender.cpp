#include "tasksender.h"
#include <QtNetwork>
#include <iostream>

TaskSender::TaskSender(QObject *parent):
    QObject (parent)
{
    server = new QLocalServer(this);
    connect(server, &QLocalServer::newConnection, this, &TaskSender::sendTask);
    server->listen("dronespos");
}

void TaskSender::appendTask(QString taskInfo)
{
    //split into json blocks
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
    connect(clientConnection, &QLocalSocket::disconnected, clientConnection, &QLocalSocket:: deleteLater);
    clientConnection->write(block);
    clientConnection->flush();
    clientConnection->disconnectFromServer();

    //emit taskSent(); //not implemented yet
    return true;
}
