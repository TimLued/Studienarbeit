#ifndef POSSOURCE_H
#define POSSOURCE_H
#include <QObject>
#include <QDateTime>

//class QTimer;
class QFile;
class QTimer;

class PosSource: public QObject
{
    Q_OBJECT
public:
    explicit PosSource(QObject *parent = nullptr);
    bool running;

public slots:
    void startStop(bool, bool);
    void loadFile(QString file);
    void setRunning(bool);

private slots:
    //void readNextPos();
    void uavTick();

signals:
    void posUpdated(QString);

private:
    QList<QString> droneInfo;
    QTimer *uavTimer;
    QDateTime currentTimeStamp;
    int currentIndex;

};

#endif // POSSOURCE_H
