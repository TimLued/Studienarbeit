#include "clientapplication.h"

#include <QtCore>
#include <QTextEdit>
#include <QLabel>
#include <QVBoxLayout>
#include <QDialogButtonBox>
#include <QListWidgetItem>

#include <possource.h>
#include <clientsocket.h>

#include <QThread>

#include <iostream>

static QList<QString> files = {":/drone1.txt",":/drone2.txt",":/drone3.txt",":/drone4.txt",":/drone5.txt",":/drone6.txt",":/drone7.txt"};

ClientApplication::ClientApplication(QWidget *parent)
    : QDialog(parent)
{
    //Local Server
    mySocket = new ClientSocket;
    t = new QThread;
    connect(mySocket, SIGNAL(updateList(QString)),this,SLOT(updateList(QString)));
    connect(mySocket, SIGNAL(clearList()),this,SLOT(clearList()));
    connect(mySocket, SIGNAL(updateBuffer(int)),this,SLOT(updateBuffer(int)));
    connect(mySocket, SIGNAL(updateStatus()),this,SLOT(updateStatus()));  
    connect(this, SIGNAL(startServer()),mySocket,SLOT(startServer()));

    //Layout
    this->setFixedSize(600,450);
    setWindowFlags(windowFlags() | Qt::WindowMinimizeButtonHint);
    QGridLayout *mainLayout = new QGridLayout(this);
    QDialogButtonBox *buttonBox = new QDialogButtonBox;

    txtEdit = new QTextEdit(this);
    bufferLbl = new QLabel(this);
    bufferLbl->setText("Buffer: 0");
    statusLbl = new QLabel(this);
    statusLbl->setText("disconnected");
    statusLbl->setStyleSheet("QLabel {color : red; }");
    droneLW = new QListWidget(this);
    droneLW->setSelectionMode(QAbstractItemView::SingleSelection);
    connect(droneLW, SIGNAL(itemChanged(QListWidgetItem*)), this,SLOT  (itemChanged()));
    startBtn = new QPushButton("Start",this);
    resetBtn = new QPushButton("Reset",this);
    connect(startBtn,SIGNAL(clicked()),this,SLOT(startStopUpdates()));
    connect(resetBtn,SIGNAL(clicked()),mySocket,SLOT(resetBuffer()));
    buttonBox->addButton(startBtn, QDialogButtonBox::ActionRole);
    buttonBox->addButton(resetBtn, QDialogButtonBox::RejectRole);
    //fromRow, fromColumn, rowSpan, columnSpan
    mainLayout->addWidget(bufferLbl,0,0);
    mainLayout->addWidget(statusLbl,1,0);
    mainLayout->addWidget(txtEdit,2,0,1,2);
    mainLayout->addWidget(buttonBox,3,0,1,4);
    mainLayout->addWidget(droneLW,2,3,1,1);
    mainLayout->setColumnStretch(1,5);
    mainLayout->setColumnStretch(3,2);

    mySocket->moveToThread(t);
    t->start();

    //load txt
    QListWidgetItem* droneItem;

    for (int i=0;i<files.count();i++){
        source = new PosSource;
        source->setupSource(files[i],i);
        sources.append(source);
        t = new QThread;
        connect(this, SIGNAL(startStop()),source,SLOT(startStop()));
        connect(source, SIGNAL(posUpdated(QString)),mySocket,SLOT(loadToBuffer(QString))); //Buffer of ClientSocket
        connect(this, SIGNAL(setRunning(bool,int)),source,SLOT(setRunning(bool,int)));
        source->moveToThread(t);

        t->start();

        //ListView
        droneItem = new QListWidgetItem;
        droneItem->setData( Qt::DisplayRole, files[i] );
        droneItem->setData( Qt::CheckStateRole, Qt::Checked );
        droneLW->addItem(droneItem);
    }

    emit startServer();

}

void ClientApplication::itemChanged()
{
    for (int i = 0; i<droneLW->count();++i){
         emit setRunning(droneLW->item(i)->checkState(),i);
    }
}

static bool enabled = false;
void ClientApplication::startStopUpdates()
{
    emit startStop();
    //Switch Button text
    if (!enabled)
    {
        startBtn->setText("Stop");
    }else{
        startBtn->setText("Start");
    }
    enabled = !enabled;
}

//SIGNALS
void ClientApplication::updateList(QString text){
     txtEdit->append(text);
}

void ClientApplication::clearList(){
    txtEdit->clear();
}

void ClientApplication::updateBuffer(int nr){
    bufferLbl->setText("Buffer: " + QString::number(nr));
}

void ClientApplication::updateStatus(){
    statusLbl->setText("connected");
    statusLbl->setStyleSheet("QLabel {color : green; }");
}
