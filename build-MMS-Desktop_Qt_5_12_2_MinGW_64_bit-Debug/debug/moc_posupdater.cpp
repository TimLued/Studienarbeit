/****************************************************************************
** Meta object code from reading C++ file 'posupdater.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../MMS/posupdater.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'posupdater.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_PosUpdater_t {
    QByteArrayData data[10];
    char stringdata0[88];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_PosUpdater_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_PosUpdater_t qt_meta_stringdata_PosUpdater = {
    {
QT_MOC_LITERAL(0, 0, 10), // "PosUpdater"
QT_MOC_LITERAL(1, 11, 10), // "posUpdated"
QT_MOC_LITERAL(2, 22, 0), // ""
QT_MOC_LITERAL(3, 23, 9), // "droneInfo"
QT_MOC_LITERAL(4, 33, 14), // "QGeoCoordinate"
QT_MOC_LITERAL(5, 48, 3), // "pos"
QT_MOC_LITERAL(6, 52, 9), // "timestamp"
QT_MOC_LITERAL(7, 62, 10), // "requestPos"
QT_MOC_LITERAL(8, 73, 7), // "readPos"
QT_MOC_LITERAL(9, 81, 6) // "update"

    },
    "PosUpdater\0posUpdated\0\0droneInfo\0"
    "QGeoCoordinate\0pos\0timestamp\0requestPos\0"
    "readPos\0update"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_PosUpdater[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       4,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    3,   34,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       7,    0,   41,    2, 0x0a /* Public */,
       8,    0,   42,    2, 0x08 /* Private */,
       9,    0,   43,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString, 0x80000000 | 4, QMetaType::QDateTime,    3,    5,    6,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void PosUpdater::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<PosUpdater *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->posUpdated((*reinterpret_cast< QString(*)>(_a[1])),(*reinterpret_cast< QGeoCoordinate(*)>(_a[2])),(*reinterpret_cast< QDateTime(*)>(_a[3]))); break;
        case 1: _t->requestPos(); break;
        case 2: _t->readPos(); break;
        case 3: _t->update(); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 1:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (PosUpdater::*)(QString , QGeoCoordinate , QDateTime );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&PosUpdater::posUpdated)) {
                *result = 0;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject PosUpdater::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_PosUpdater.data,
    qt_meta_data_PosUpdater,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *PosUpdater::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *PosUpdater::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_PosUpdater.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int PosUpdater::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void PosUpdater::posUpdated(QString _t1, QGeoCoordinate _t2, QDateTime _t3)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
