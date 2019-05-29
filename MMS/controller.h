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
    Controller(){
        up = new PosUpdater;
        t = new QThread;
        up->moveToThread(t);
        connect(this, SIGNAL(start()), up, SLOT(requestPos()));
        connect(up, SIGNAL(posUpdated(QString,QGeoCoordinate,QDateTime)), this, SIGNAL(posUpdated(QString,QGeoCoordinate,QDateTime)));
        t->start();
    }

private:
   PosUpdater* up;
   QThread* t;

signals:
    void start();
    void posUpdated(QString droneInfo, QGeoCoordinate pos, QDateTime timestamp);
};

#endif // CONTROLLER_H
