#include "clientapplication.h"

#include <QtCore>
#include <QTextEdit>
#include <QLabel>
#include <QVBoxLayout>
#include <QDialogButtonBox>
#include <QListWidgetItem>

#include <possource.h>

#include <QThread>

#include <iostream>

#include <QtNetwork>


static QList<QString> files = {":/jdrone1.txt",
                               ":/jdrone2.txt",
                               ":/jdrone3.txt",
                               ":/jdrone4.txt",
                               ":/jdroneV1.txt",
                               ":/jwp.txt"};

ClientApplication::ClientApplication(QWidget *parent)
    : QDialog(parent),
      timer(new QTimer(this))
{
    //Local Server
    server = new QLocalServer(this);
    connect(server, &QLocalServer::newConnection, this, &ClientApplication::nextPos);

    //Layout
    //this->setFixedSize(600,450);
    setWindowFlags(windowFlags() | Qt::WindowMinimizeButtonHint);
    QGridLayout *mainLayout = new QGridLayout(this);
    QDialogButtonBox *buttonBox = new QDialogButtonBox;

    bufferLbl = new QLabel(this);
    bufferLbl->setText("Buffer: 0");
    statusLbl = new QLabel(this);
    statusLbl->setText("disconnected");
    statusLbl->setStyleSheet("QLabel {color : red; }");
    droneLW = new QListWidget(this);
    droneLW->setSelectionMode(QAbstractItemView::SingleSelection);
    connect(droneLW, SIGNAL(itemChanged(QListWidgetItem*)), this,SLOT  (itemChanged()));
    startBtn = new QPushButton("Start",this);
    startBtn->setCheckable(true);
    resetBtn = new QPushButton("Reset",this);
    startAllBtn = new QPushButton("ALL",this);
    loadBtn = new QPushButton("Load",this);

    connect(startBtn,SIGNAL(clicked()),this,SLOT(startStopUpdates()));
    connect(resetBtn,SIGNAL(clicked()),this,SLOT(resetBuffer()));
    connect(startAllBtn,SIGNAL(clicked()),this,SLOT(startAll()));
    connect(loadBtn,SIGNAL(clicked()),this,SLOT(loadDrone()));
    buttonBox->addButton(startBtn, QDialogButtonBox::ActionRole);
    buttonBox->addButton(resetBtn, QDialogButtonBox::RejectRole);
    buttonBox->addButton(startAllBtn, QDialogButtonBox::RejectRole);
    buttonBox->addButton(loadBtn, QDialogButtonBox::RejectRole);
    //fromRow, fromColumn, rowSpan, columnSpan
    mainLayout->addWidget(bufferLbl,0,0);
    mainLayout->addWidget(statusLbl,1,0);
    mainLayout->addWidget(buttonBox,3,0,1,1);
    mainLayout->addWidget(droneLW,2,0);

    //t->start();

    //load txt
    QListWidgetItem* droneItem;

    for (int i=0;i<files.count();i++){
        source = new PosSource;
        source->setupSource(files[i],i);
        sources.append(source);
        t = new QThread;
        connect(this, SIGNAL(startStop(bool,bool)),source,SLOT(startStop(bool,bool)));
        connect(this, SIGNAL(setRunning(bool,int)),source,SLOT(setRunning(bool,int)));
        connect(source, SIGNAL(posUpdated(QString)),this,SLOT(loadToBuffer(QString))); //Buffer of ClientSocket
        source->moveToThread(t);

        t->start();

        //ListView
        droneItem = new QListWidgetItem;
        droneItem->setData( Qt::DisplayRole, files[i] );
        droneItem->setData( Qt::CheckStateRole, Qt::Unchecked );
        droneLW->addItem(droneItem);
    }

    server->listen("dronespos");

    connect(timer,SIGNAL(timeout()),this,SLOT(startAllStep()));
}

void ClientApplication::loadToBuffer(QString info){
    buffer.append(info);
    bufferLbl->setText("Buffer: " + QString::number(buffer.count()));
}

void ClientApplication::resetBuffer(){
     buffer.clear();
     bufferLbl->setText("Buffer: " + QString::number(buffer.count()));
     for (int i = 0; i<droneLW->count();++i){
         droneLW->item(i)->setCheckState(Qt::CheckState::Unchecked);
     }
}


void ClientApplication::itemChanged()
{
    for (int i = 0; i<droneLW->count();++i){
         emit setRunning(droneLW->item(i)->checkState(),i);
    }
}

void ClientApplication::startStopUpdates()
{
    if (startBtn->isChecked()){
        emit startStop(1,0);
        startBtn->setText("Stop");
    }else{
        emit startStop(0,0);
        startBtn->setText("Start");
    }
}

void ClientApplication::loadDrone(){emit startStop(1,1);}

void ClientApplication::startAll()
{
    for (int i = 0; i<droneLW->count();++i){
        droneLW->item(i)->setCheckState(Qt::CheckState::Unchecked);
    }
    timer->start(2000);
}

void ClientApplication::startAllStep()
{
    for (int k = 0; k<droneLW->count()-1;++k){
        if (droneLW->item(k)->checkState() == Qt::CheckState::Unchecked){
            startBtn->setChecked(0);
            startStopUpdates();
            droneLW->item(k)->setCheckState(Qt::CheckState::Checked);
            startBtn->setChecked(1);
            startStopUpdates();

            if (k==droneLW->count()-2)timer->stop();
            break;
        }
    }
}

bool ClientApplication::nextPos()
{
    try {
        statusLbl->setText("connected");
        statusLbl->setStyleSheet("QLabel {color : green; }");

        QString line;
        if (buffer.empty()){
            QLocalSocket *clientConnection = server->nextPendingConnection();
            clientConnection->disconnectFromServer();
            return false;
        }
        line = buffer.first();
        buffer.removeFirst();
        bufferLbl->setText("Buffer: " + QString::number(buffer.count()));
        //emit updateList(line.trimmed());
        //        }else{
        //            line="-";
        //        }

        QByteArray block;
        QDataStream out(&block, QIODevice::WriteOnly);
        out << quint32(line.size());
        out << line;

        QLocalSocket *clientConnection = server->nextPendingConnection();
        connect(clientConnection, QOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::error),this, &ClientApplication::serverError);
        connect(clientConnection, &QLocalSocket::disconnected, clientConnection, &QLocalSocket:: deleteLater);
        clientConnection->write(block);
        clientConnection->flush();
        clientConnection->disconnectFromServer();

    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
    }
    return true;
}

void ClientApplication::serverError()
{
    std::cout << server->errorString().toUtf8().constData() << std::endl;
}

