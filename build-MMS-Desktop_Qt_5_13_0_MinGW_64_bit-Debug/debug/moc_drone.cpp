/****************************************************************************
** Meta object code from reading C++ file 'drone.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../MMS/drone.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'drone.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Task_t {
    QByteArrayData data[7];
    char stringdata0[52];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Task_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Task_t qt_meta_stringdata_Task = {
    {
QT_MOC_LITERAL(0, 0, 4), // "Task"
QT_MOC_LITERAL(1, 5, 2), // "id"
QT_MOC_LITERAL(2, 8, 7), // "mission"
QT_MOC_LITERAL(3, 16, 7), // "geoType"
QT_MOC_LITERAL(4, 24, 8), // "taskType"
QT_MOC_LITERAL(5, 33, 3), // "pos"
QT_MOC_LITERAL(6, 37, 14) // "QGeoCoordinate"

    },
    "Task\0id\0mission\0geoType\0taskType\0pos\0"
    "QGeoCoordinate"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Task[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       5,   14, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       4,       // flags
       0,       // signalCount

 // properties: name, type, flags
       1, QMetaType::QString, 0x00095003,
       2, QMetaType::QString, 0x00095003,
       3, QMetaType::QString, 0x00095003,
       4, QMetaType::QString, 0x00095003,
       5, 0x80000000 | 6, 0x0009500b,

       0        // eod
};

void Task::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 4:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
        }
    }

#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = reinterpret_cast<Task *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->id; break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->mission; break;
        case 2: *reinterpret_cast< QString*>(_v) = _t->geoType; break;
        case 3: *reinterpret_cast< QString*>(_v) = _t->taskType; break;
        case 4: *reinterpret_cast< QGeoCoordinate*>(_v) = _t->pos; break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = reinterpret_cast<Task *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0:
            if (_t->id != *reinterpret_cast< QString*>(_v)) {
                _t->id = *reinterpret_cast< QString*>(_v);
            }
            break;
        case 1:
            if (_t->mission != *reinterpret_cast< QString*>(_v)) {
                _t->mission = *reinterpret_cast< QString*>(_v);
            }
            break;
        case 2:
            if (_t->geoType != *reinterpret_cast< QString*>(_v)) {
                _t->geoType = *reinterpret_cast< QString*>(_v);
            }
            break;
        case 3:
            if (_t->taskType != *reinterpret_cast< QString*>(_v)) {
                _t->taskType = *reinterpret_cast< QString*>(_v);
            }
            break;
        case 4:
            if (_t->pos != *reinterpret_cast< QGeoCoordinate*>(_v)) {
                _t->pos = *reinterpret_cast< QGeoCoordinate*>(_v);
            }
            break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
    Q_UNUSED(_o);
}

QT_INIT_METAOBJECT const QMetaObject Task::staticMetaObject = { {
    nullptr,
    qt_meta_stringdata_Task.data,
    qt_meta_data_Task,
    qt_static_metacall,
    nullptr,
    nullptr
} };

QT_WARNING_POP
QT_END_MOC_NAMESPACE
