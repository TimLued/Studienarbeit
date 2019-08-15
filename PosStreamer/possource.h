#ifndef POSSOURCE_H
#define POSSOURCE_H
#include <QObject>

class QTimer;
class QFile;

class PosSource: public QObject
{
    Q_OBJECT
public:
    explicit PosSource(QObject *parent = nullptr);
    bool running;

public slots:
    void startStop(bool, bool);
    void setupSource(QString,int);
    void setRunning(bool,int);

private slots:
    void readNextPos();

signals:
    void posUpdated(QString);

private:
    QTimer *timer;
    QString lastInfo;
    int lvIndex;
    QList<QString> droneInfo;
    int currentInfoIndex;

};

#endif // POSSOURCE_H
