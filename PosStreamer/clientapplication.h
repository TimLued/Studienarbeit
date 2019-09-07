#ifndef CLIENTAPPLICATION_H
#define CLIENTAPPLICATION_H

#include <QDialog>

#include <QTextEdit>
#include <QLabel>
#include <QPushButton>
#include <QListView>
#include <QListWidget>

#include <possource.h>

class QLocalServer;
class QTimer;

class ClientApplication : public QDialog
{
    Q_OBJECT
public:
    ClientApplication(QWidget *parent= nullptr);

private:
    QList<PosSource*> sources;

    QLabel *bufferLbl;
    QLabel *statusLbl;
    QPushButton *startBtn;
    QPushButton *resetBtn;
    QPushButton *startAllBtn;
    QPushButton *loadBtn;
    QListWidget *droneLW;

    PosSource* source;
    QThread* t;
    QLocalServer *server;
    void serverError();
    QList<QString> buffer;
    QTimer *timer;

private slots:
    void startStopUpdates();
    void itemChanged();
    void startAll();
    void startAllStep();
    void loadDrone();

    void loadToBuffer(QString);
    void resetBuffer();
    bool nextPos();

    void updateBufferLabel();


signals:
    void startStop(bool,bool);
};

#endif // CLIENTAPPLICATION_H
