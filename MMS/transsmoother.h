#ifndef TRANSSMOOTHER_H
#define TRANSSMOOTHER_H

#include <QObject>
#include <QGeoCoordinate>

class QTimer;

class TransSmoother: public QObject
{
    Q_OBJECT
public:
    explicit TransSmoother(QObject* parent = nullptr);

public slots:
    Q_INVOKABLE void start(int interval, double dist, double bearing, QGeoCoordinate lastCor);
    Q_INVOKABLE void stop();
private:
    QTimer *timer;
    QGeoCoordinate cor;
    double mDist;
    double mBearing;
    int mInterval;

private slots:
    void timeTrigger();

signals:
    void posUpdate(QGeoCoordinate cor);
};

#endif // TRANSSMOOTHER_H
