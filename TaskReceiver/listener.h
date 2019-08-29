#ifndef LISTENER_H
#define LISTENER_H

#include <QObject>
#include <QDataStream>
#include <QLocalSocket>


class QLocalSocket;
class QTimer;

class Listener: public QObject
{
    Q_OBJECT
public:
    explicit Listener(QObject *parent = nullptr);

signals:
    void taskReceived(QString task);

private:
    QLocalSocket *socket;
    QDataStream in;
    quint32 blockSize;

    QTimer *timer;

private slots:
    void readTask();
    void recon();
    void requestTask();
};

#endif // LISTENER_H
