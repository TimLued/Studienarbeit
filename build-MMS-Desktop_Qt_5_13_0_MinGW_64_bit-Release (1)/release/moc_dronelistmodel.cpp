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
    QByteArrayData data[35];
    char stringdata0[376];
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
QT_MOC_LITERAL(4, 34, 11), // "updateTasks"
QT_MOC_LITERAL(5, 46, 11), // "createDrone"
QT_MOC_LITERAL(6, 58, 2), // "id"
QT_MOC_LITERAL(7, 61, 8), // "setColor"
QT_MOC_LITERAL(8, 70, 5), // "color"
QT_MOC_LITERAL(9, 76, 21), // "toggleHistoryTracking"
QT_MOC_LITERAL(10, 98, 18), // "toggleShowingRoute"
QT_MOC_LITERAL(11, 117, 12), // "toggleFollow"
QT_MOC_LITERAL(12, 130, 13), // "setVisibility"
QT_MOC_LITERAL(13, 144, 10), // "visibility"
QT_MOC_LITERAL(14, 155, 19), // "setSelectedInfoList"
QT_MOC_LITERAL(15, 175, 4), // "info"
QT_MOC_LITERAL(16, 180, 21), // "setUnselectedInfoList"
QT_MOC_LITERAL(17, 202, 15), // "getInfoNameList"
QT_MOC_LITERAL(18, 218, 14), // "getAllDronePos"
QT_MOC_LITERAL(19, 233, 11), // "getDronePos"
QT_MOC_LITERAL(20, 245, 8), // "getRoute"
QT_MOC_LITERAL(21, 254, 8), // "setGroup"
QT_MOC_LITERAL(22, 263, 5), // "group"
QT_MOC_LITERAL(23, 269, 15), // "setHistoryRange"
QT_MOC_LITERAL(24, 285, 5), // "start"
QT_MOC_LITERAL(25, 291, 3), // "end"
QT_MOC_LITERAL(26, 295, 12), // "switchMarked"
QT_MOC_LITERAL(27, 308, 8), // "getTasks"
QT_MOC_LITERAL(28, 317, 6), // "setLeg"
QT_MOC_LITERAL(29, 324, 1), // "i"
QT_MOC_LITERAL(30, 326, 14), // "QGeoCoordinate"
QT_MOC_LITERAL(31, 341, 4), // "from"
QT_MOC_LITERAL(32, 346, 2), // "to"
QT_MOC_LITERAL(33, 349, 15), // "setDisplayedLeg"
QT_MOC_LITERAL(34, 365, 10) // "getLastLeg"

    },
    "DroneListModel\0updateDrone\0\0jInfo\0"
    "updateTasks\0createDrone\0id\0setColor\0"
    "color\0toggleHistoryTracking\0"
    "toggleShowingRoute\0toggleFollow\0"
    "setVisibility\0visibility\0setSelectedInfoList\0"
    "info\0setUnselectedInfoList\0getInfoNameList\0"
    "getAllDronePos\0getDronePos\0getRoute\0"
    "setGroup\0group\0setHistoryRange\0start\0"
    "end\0switchMarked\0getTasks\0setLeg\0i\0"
    "QGeoCoordinate\0from\0to\0setDisplayedLeg\0"
    "getLastLeg"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_DroneListModel[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      23,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,  129,    2, 0x02 /* Public */,
       4,    1,  132,    2, 0x02 /* Public */,
       5,    1,  135,    2, 0x02 /* Public */,
       7,    2,  138,    2, 0x02 /* Public */,
       9,    1,  143,    2, 0x02 /* Public */,
      10,    1,  146,    2, 0x02 /* Public */,
      11,    1,  149,    2, 0x02 /* Public */,
      12,    2,  152,    2, 0x02 /* Public */,
      14,    2,  157,    2, 0x02 /* Public */,
      16,    2,  162,    2, 0x02 /* Public */,
      17,    1,  167,    2, 0x02 /* Public */,
      18,    0,  170,    2, 0x02 /* Public */,
      19,    1,  171,    2, 0x02 /* Public */,
      20,    1,  174,    2, 0x02 /* Public */,
      21,    2,  177,    2, 0x02 /* Public */,
      23,    3,  182,    2, 0x02 /* Public */,
      26,    1,  189,    2, 0x02 /* Public */,
      27,    1,  192,    2, 0x02 /* Public */,
      28,    4,  195,    2, 0x02 /* Public */,
      28,    3,  204,    2, 0x22 /* Public | MethodCloned */,
      28,    2,  211,    2, 0x22 /* Public | MethodCloned */,
      33,    2,  216,    2, 0x02 /* Public */,
      34,    1,  221,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,    6,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    6,    8,
    QMetaType::Void, QMetaType::QString,    6,
    QMetaType::Void, QMetaType::QString,    6,
    QMetaType::Void, QMetaType::QString,    6,
    QMetaType::Void, QMetaType::QString, QMetaType::Bool,    6,   13,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,    6,   15,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,    6,   15,
    QMetaType::QVariant, QMetaType::QString,    6,
    QMetaType::QVariant,
    QMetaType::QVariant, QMetaType::QString,    6,
    QMetaType::QVariant, QMetaType::QString,    6,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    6,   22,
    QMetaType::Void, QMetaType::QString, QMetaType::Int, QMetaType::Int,    6,   24,   25,
    QMetaType::Void, QMetaType::QString,    6,
    QMetaType::QVariant, QMetaType::QString,    6,
    QMetaType::Void, QMetaType::QString, QMetaType::Int, 0x80000000 | 30, 0x80000000 | 30,    6,   29,   31,   32,
    QMetaType::Void, QMetaType::QString, QMetaType::Int, 0x80000000 | 30,    6,   29,   31,
    QMetaType::Void, QMetaType::QString, QMetaType::Int,    6,   29,
    QMetaType::Void, QMetaType::QString, QMetaType::Int,    6,   29,
    QMetaType::Int, QMetaType::QString,    6,

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
        case 1: { bool _r = _t->updateTasks((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 2: { bool _r = _t->createDrone((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 3: _t->setColor((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 4: _t->toggleHistoryTracking((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 5: _t->toggleShowingRoute((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 6: _t->toggleFollow((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 7: _t->setVisibility((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        case 8: { bool _r = _t->setSelectedInfoList((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 9: { bool _r = _t->setUnselectedInfoList((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 10: { QVariant _r = _t->getInfoNameList((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 11: { QVariant _r = _t->getAllDronePos();
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 12: { QVariant _r = _t->getDronePos((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 13: { QVariant _r = _t->getRoute((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 14: _t->setGroup((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 15: _t->setHistoryRange((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 16: _t->switchMarked((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 17: { QVariant _r = _t->getTasks((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 18: _t->setLeg((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< QGeoCoordinate(*)>(_a[3])),(*reinterpret_cast< QGeoCoordinate(*)>(_a[4]))); break;
        case 19: _t->setLeg((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< QGeoCoordinate(*)>(_a[3]))); break;
        case 20: _t->setLeg((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 21: _t->setDisplayedLeg((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 22: { int _r = _t->getLastLeg((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 18:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 3:
            case 2:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
            }
            break;
        case 19:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 2:
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
        if (_id < 23)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 23;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 23)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 23;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
