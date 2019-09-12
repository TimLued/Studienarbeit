/****************************************************************************
** Meta object code from reading C++ file 'dronelistmodel.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../MMS/dronelistmodel.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'dronelistmodel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.0. It"
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

struct qt_meta_stringdata_Waypoint_t {
    QByteArrayData data[4];
    char stringdata0[20];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Waypoint_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Waypoint_t qt_meta_stringdata_Waypoint = {
    {
QT_MOC_LITERAL(0, 0, 8), // "Waypoint"
QT_MOC_LITERAL(1, 9, 2), // "id"
QT_MOC_LITERAL(2, 12, 3), // "lat"
QT_MOC_LITERAL(3, 16, 3) // "lon"

    },
    "Waypoint\0id\0lat\0lon"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Waypoint[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       3,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       4,       // flags
       0,       // signalCount

 // properties: name, type, flags
       1, QMetaType::QString, 0x00095003,
       2, QMetaType::QString, 0x00095003,
       3, QMetaType::QString, 0x00095003,

       0        // eod
};

void Waypoint::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{

#ifndef QT_NO_PROPERTIES
    if (_c == QMetaObject::ReadProperty) {
        auto *_t = reinterpret_cast<Waypoint *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->id; break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->lat; break;
        case 2: *reinterpret_cast< QString*>(_v) = _t->lon; break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = reinterpret_cast<Waypoint *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0:
            if (_t->id != *reinterpret_cast< QString*>(_v)) {
                _t->id = *reinterpret_cast< QString*>(_v);
            }
            break;
        case 1:
            if (_t->lat != *reinterpret_cast< QString*>(_v)) {
                _t->lat = *reinterpret_cast< QString*>(_v);
            }
            break;
        case 2:
            if (_t->lon != *reinterpret_cast< QString*>(_v)) {
                _t->lon = *reinterpret_cast< QString*>(_v);
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

QT_INIT_METAOBJECT const QMetaObject Waypoint::staticMetaObject = { {
    nullptr,
    qt_meta_stringdata_Waypoint.data,
    qt_meta_data_Waypoint,
    qt_static_metacall,
    nullptr,
    nullptr
} };

struct qt_meta_stringdata_DroneListModel_t {
    QByteArrayData data[25];
    char stringdata0[283];
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
QT_MOC_LITERAL(6, 49, 8), // "setColor"
QT_MOC_LITERAL(7, 58, 5), // "color"
QT_MOC_LITERAL(8, 64, 21), // "toggleHistoryTracking"
QT_MOC_LITERAL(9, 86, 18), // "toggleShowingRoute"
QT_MOC_LITERAL(10, 105, 12), // "toggleFollow"
QT_MOC_LITERAL(11, 118, 13), // "setVisibility"
QT_MOC_LITERAL(12, 132, 10), // "visibility"
QT_MOC_LITERAL(13, 143, 19), // "setSelectedInfoList"
QT_MOC_LITERAL(14, 163, 4), // "info"
QT_MOC_LITERAL(15, 168, 21), // "setUnselectedInfoList"
QT_MOC_LITERAL(16, 190, 15), // "getInfoNameList"
QT_MOC_LITERAL(17, 206, 14), // "getAllDronePos"
QT_MOC_LITERAL(18, 221, 11), // "getDronePos"
QT_MOC_LITERAL(19, 233, 8), // "getRoute"
QT_MOC_LITERAL(20, 242, 8), // "setGroup"
QT_MOC_LITERAL(21, 251, 5), // "group"
QT_MOC_LITERAL(22, 257, 15), // "setHistoryRange"
QT_MOC_LITERAL(23, 273, 5), // "start"
QT_MOC_LITERAL(24, 279, 3) // "end"

    },
    "DroneListModel\0updateDrone\0\0jInfo\0"
    "createDrone\0id\0setColor\0color\0"
    "toggleHistoryTracking\0toggleShowingRoute\0"
    "toggleFollow\0setVisibility\0visibility\0"
    "setSelectedInfoList\0info\0setUnselectedInfoList\0"
    "getInfoNameList\0getAllDronePos\0"
    "getDronePos\0getRoute\0setGroup\0group\0"
    "setHistoryRange\0start\0end"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_DroneListModel[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      15,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   89,    2, 0x02 /* Public */,
       4,    1,   92,    2, 0x02 /* Public */,
       6,    2,   95,    2, 0x02 /* Public */,
       8,    1,  100,    2, 0x02 /* Public */,
       9,    1,  103,    2, 0x02 /* Public */,
      10,    1,  106,    2, 0x02 /* Public */,
      11,    2,  109,    2, 0x02 /* Public */,
      13,    2,  114,    2, 0x02 /* Public */,
      15,    2,  119,    2, 0x02 /* Public */,
      16,    1,  124,    2, 0x02 /* Public */,
      17,    0,  127,    2, 0x02 /* Public */,
      18,    1,  128,    2, 0x02 /* Public */,
      19,    1,  131,    2, 0x02 /* Public */,
      20,    2,  134,    2, 0x02 /* Public */,
      22,    3,  139,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    5,    7,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::Bool,    5,   12,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,    5,   14,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,    5,   14,
    QMetaType::QVariant, QMetaType::QString,    5,
    QMetaType::QVariant,
    QMetaType::QVariant, QMetaType::QString,    5,
    QMetaType::QVariant, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    5,   21,
    QMetaType::Void, QMetaType::QString, QMetaType::Int, QMetaType::Int,    5,   23,   24,

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
        case 1: { bool _r = _t->createDrone((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 2: _t->setColor((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 3: _t->toggleHistoryTracking((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 4: _t->toggleShowingRoute((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 5: _t->toggleFollow((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 6: _t->setVisibility((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        case 7: { bool _r = _t->setSelectedInfoList((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 8: { bool _r = _t->setUnselectedInfoList((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 9: { QVariant _r = _t->getInfoNameList((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 10: { QVariant _r = _t->getAllDronePos();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 11: { QVariant _r = _t->getDronePos((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 12: { QVariant _r = _t->getRoute((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 13: _t->setGroup((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 14: _t->setHistoryRange((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        default: ;
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
        if (_id < 15)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 15;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 15)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 15;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
