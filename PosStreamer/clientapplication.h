#ifndef CLIENTAPPLICATION_H
#define CLIENTAPPLICATION_H

#include <QDialog>

#include <QTextEdit>
#include <QLabel>
#include <QPushButton>
#include <QListView>
#include <QListWidget>

#include <possource.h>
#include <clientsocket.h>

class ClientApplication : public QDialog
{
    Q_OBJECT
public:
    explicit ClientApplication(QWidget *parent = nullptr);

private:
    QList<PosSource*> sources;

    QTextEdit *txtEdit;
    QLabel *bufferLbl;
    QLabel *statusLbl;
    QPushButton *startBtn;
    QPushButton *resetBtn;
    QListWidget *droneLW;

    PosSource* source;
    QThread* t;
    ClientSocket* mySocket;

private slots:
    void startStopUpdates();
    void itemChanged();

public slots:
    void updateList(QString);
    void clearList();
    void updateBuffer(int);
    void updateStatus();

signals:
    void startStop();
    void startServer();
    void setRunning(bool,int);
};

#endif // CLIENTAPPLICATION_H
