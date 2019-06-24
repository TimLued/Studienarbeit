/****************************************************************************
** Meta object code from reading C++ file 'dronelistmodel.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../MMS/dronelistmodel.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'dronelistmodel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Info_t {
    QByteArrayData data[3];
    char stringdata0[16];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Info_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Info_t qt_meta_stringdata_Info = {
    {
QT_MOC_LITERAL(0, 0, 4), // "Info"
QT_MOC_LITERAL(1, 5, 4), // "name"
QT_MOC_LITERAL(2, 10, 5) // "value"

    },
    "Info\0name\0value"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Info[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       2,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       4,       // flags
       0,       // signalCount

 // properties: name, type, flags
       1, QMetaType::QString, 0x00095003,
       2, QMetaType::QString, 0x00095003,

       0        // eod
};

void Info::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{

#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty) {
        auto *_t = reinterpret_cast<Info *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->name; break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->value; break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = reinterpret_cast<Info *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0:
            if (_t->name != *reinterpret_cast< QString*>(_v)) {
                _t->name = *reinterpret_cast< QString*>(_v);
            }
            break;
        case 1:
            if (_t->value != *reinterpret_cast< QString*>(_v)) {
                _t->value = *reinterpret_cast< QString*>(_v);
            }
            break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

QT_INIT_METAOBJECT const QMetaObject Info::staticMetaObject = { {
    nullptr,
    qt_meta_stringdata_Info.data,
    qt_meta_data_Info,
    qt_static_metacall,
    nullptr,
    nullptr
} };

struct qt_meta_stringdata_DroneListModel_t {
    QByteArrayData data[20];
    char stringdata0[240];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_DroneListModel_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_DroneListModel_t qt_meta_stringdata_DroneListModel = {
    {
QT_MOC_LITERAL(0, 0, 14), // "DroneListModel"
QT_MOC_LITERAL(1, 15, 11), // "updateDrone"
QT_MOC_LITERAL(2, 27, 0), // ""
QT_MOC_LITERAL(3, 28, 5), // "jInfo"
QT_MOC_LITERAL(4, 34, 11), // "createDrone"
QT_MOC_LITERAL(5, 46, 2), // "id"
QT_MOC_LITERAL(6, 49, 14), // "QGeoCoordinate"
QT_MOC_LITERAL(7, 64, 5), // "coord"
QT_MOC_LITERAL(8, 70, 15), // "getDroneHistory"
QT_MOC_LITERAL(9, 86, 8), // "setColor"
QT_MOC_LITERAL(10, 95, 5), // "color"
QT_MOC_LITERAL(11, 101, 21), // "toggleHistoryTracking"
QT_MOC_LITERAL(12, 123, 12), // "toggleFollow"
QT_MOC_LITERAL(13, 136, 13), // "setVisibility"
QT_MOC_LITERAL(14, 150, 10), // "visibility"
QT_MOC_LITERAL(15, 161, 15), // "getInfoNameList"
QT_MOC_LITERAL(16, 177, 20), // "setSeelectedInfoList"
QT_MOC_LITERAL(17, 198, 4), // "info"
QT_MOC_LITERAL(18, 203, 21), // "setUnselectedInfoList"
QT_MOC_LITERAL(19, 225, 14) // "getAllDronePos"

    },
    "DroneListModel\0updateDrone\0\0jInfo\0"
    "createDrone\0id\0QGeoCoordinate\0coord\0"
    "getDroneHistory\0setColor\0color\0"
    "toggleHistoryTracking\0toggleFollow\0"
    "setVisibility\0visibility\0getInfoNameList\0"
    "setSeelectedInfoList\0info\0"
    "setUnselectedInfoList\0getAllDronePos"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_DroneListModel[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      11,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   69,    2, 0x02 /* Public */,
       4,    2,   72,    2, 0x02 /* Public */,
       8,    1,   77,    2, 0x02 /* Public */,
       9,    2,   80,    2, 0x02 /* Public */,
      11,    1,   85,    2, 0x02 /* Public */,
      12,    1,   88,    2, 0x02 /* Public */,
      13,    2,   91,    2, 0x02 /* Public */,
      15,    1,   96,    2, 0x02 /* Public */,
      16,    2,   99,    2, 0x02 /* Public */,
      18,    2,  104,    2, 0x02 /* Public */,
      19,    0,  109,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString, 0x80000000 | 6,    5,    7,
    QMetaType::QVariant, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    5,   10,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::Bool,    5,   14,
    QMetaType::QVariant, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    5,   17,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    5,   17,
    QMetaType::QVariant,

       0        // eod
};

void DroneListModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<DroneListModel *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { bool _r = _t->updateDrone((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 1: { bool _r = _t->createDrone((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QGeoCoordinate(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 2: { QVariant _r = _t->getDroneHistory((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 3: _t->setColor((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 4: _t->toggleHistoryTracking((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 5: _t->toggleFollow((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 6: _t->setVisibility((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        case 7: { QVariant _r = _t->getInfoNameList((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 8: _t->setSeelectedInfoList((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 9: _t->setUnselectedInfoList((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 10: { QVariant _r = _t->getAllDronePos();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 1:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 1:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
            }
            break;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject DroneListModel::staticMetaObject = { {
    &QAbstractListModel::staticMetaObject,
    qt_meta_stringdata_DroneListModel.data,
    qt_meta_data_DroneListModel,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *DroneListModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *DroneListModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_DroneListModel.stringdata0))
        return static_cast<void*>(this);
    return QAbstractListModel::qt_metacast(_clname);
}

int DroneListModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractListModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
