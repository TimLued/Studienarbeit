#ifndef CLIENTSOCKET_H
#define CLIENTSOCKET_H
#include <QObject>
class QLocalServer;
class QTextStream;

class ClientSocket: public QObject
{
    Q_OBJECT
public:
    explicit ClientSocket(QObject *parent = nullptr);

private:
    QTextStream *stream;
    QLocalServer *server;
    QList<QString> buffer;

private slots:
    void nextPos();

public slots:
    void loadToBuffer(const QString &lastInfo);
    void resetBuffer();
    void startServer();

signals:
    //-> clientapp: append to list
    void updateList(QString);
    void clearList();
    void updateBuffer(int);
    void updateStatus();
};

#endif // CLIENTSOCKET_H
