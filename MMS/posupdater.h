#ifndef POSUPDATER_H
#define POSUPDATER_H

#include <QObject>

#include <QGeoPositionInfoSource>
#include <QGeoCoordinate>

#include <QDataStream>
#include <QLocalSocket>

class QLocalSocket;
class QTimer;

class PosUpdater: public QObject
{
    Q_OBJECT
public:
    explicit PosUpdater(QObject *parent = nullptr);

public slots:
    void requestPos();

signals:
    void posUpdated(QString droneInfo);
private:
    QDateTime lastTimestamp;

    QLocalSocket *socket;
    QDataStream in;
    quint32 blockSize;

    QTimer *timer;

private slots:
    void readPos();
    void update();

};


#endif // POSUPDATER_H
