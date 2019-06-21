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
    QString currentInfo;

    Controller(){

        up = new PosUpdater;
        t = new QThread;
        up->moveToThread(t);
        connect(this, SIGNAL(start()), up, SLOT(requestPos()));
        connect(up, SIGNAL(posUpdated(QString)), this, SLOT(updateCurrent(QString)));
        connect(t, &QThread::finished, t, &QThread::deleteLater);
        t->start();
    }

private slots:
    void updateCurrent(QString droneInfo){
        currentInfo = droneInfo;

        //json string only
        emit posUpdated();
    }

private:
   PosUpdater* up;
   QThread* t;

signals:
    void start();
    void posUpdated();
};

#endif // CONTROLLER_H
