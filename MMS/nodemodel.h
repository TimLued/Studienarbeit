#ifndef HISTORYMODEL_H
#define HISTORYMODEL_H

#include <QAbstractListModel>
#include "dronelistmodel.h"
#include <QDebug>


class NodeModel : public QAbstractListModel {
    Q_OBJECT

public:
    using QAbstractListModel::QAbstractListModel;
    enum AirportsRoles { NodeRole = Qt::UserRole + 100, AngleRole };
    void appendNode(const QGeoCoordinate &coord) {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        mData << QVariant::fromValue(coord);
        endInsertRows();
    }
    void setNode(const QVariantList &path){
        mData = path;
    }

    int rowCount(const QModelIndex &parent = QModelIndex()) const override {
        Q_UNUSED(parent)
        return mData.count();
    }

    QVariant data(const QModelIndex &index,int role = Qt::DisplayRole) const override {
        if (!index.isValid())
            return QModelIndex();
        if (index.row() >= 0 && index.row() < rowCount()) {
            if (role == NodeRole) {
                return mData[index.row()];
            }
        }
        return QModelIndex();
    }

    QHash<int, QByteArray> roleNames() const override
    {
        QHash<int, QByteArray> roles;
        roles[NodeRole] = "nodeData";
        return roles;
    }

private:
    QVariantList mData;

};

#endif // HISTORYMODEL_H
