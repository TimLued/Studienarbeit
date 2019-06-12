#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <posupdater.h>
#include <QThread>
#include <QGeoPositionInfoSource>
#include <QGeoCoordinate>

class Controller: public QObject
{
    Q_OBJECT
public:
    QGeoCoordinate currentPos;
    QString currentId;
    QDateTime currentTime;

    Controller(){

        up = new PosUpdater;
        t = new QThread;
        up->moveToThread(t);
        connect(this, SIGNAL(start()), up, SLOT(requestPos()));
        connect(up, SIGNAL(posUpdated(QString,QGeoCoordinate,QDateTime)), this, SLOT(updateCurrent(QString,QGeoCoordinate,QDateTime)));
        connect(t, &QThread::finished, t, &QThread::deleteLater);
        t->start();
    }

private slots:
    void updateCurrent(QString id,QGeoCoordinate pos,QDateTime time){
        currentPos = pos;
        currentId = id;
        currentTime = time;
        emit posUpdated(currentId,currentPos,currentTime);
    }

private:
   PosUpdater* up;
   QThread* t;

signals:
    void start();
    void posUpdated(QString droneInfo, QGeoCoordinate pos, QDateTime timestamp);
};

#endif // CONTROLLER_H
