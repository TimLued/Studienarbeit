/****************************************************************************
** Meta object code from reading C++ file 'transsmoother.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../MMS/transsmoother.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'transsmoother.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_TransSmoother_t {
    QByteArrayData data[12];
    char stringdata0[97];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_TransSmoother_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_TransSmoother_t qt_meta_stringdata_TransSmoother = {
    {
QT_MOC_LITERAL(0, 0, 13), // "TransSmoother"
QT_MOC_LITERAL(1, 14, 9), // "posUpdate"
QT_MOC_LITERAL(2, 24, 0), // ""
QT_MOC_LITERAL(3, 25, 14), // "QGeoCoordinate"
QT_MOC_LITERAL(4, 40, 3), // "cor"
QT_MOC_LITERAL(5, 44, 5), // "start"
QT_MOC_LITERAL(6, 50, 8), // "interval"
QT_MOC_LITERAL(7, 59, 4), // "dist"
QT_MOC_LITERAL(8, 64, 7), // "bearing"
QT_MOC_LITERAL(9, 72, 7), // "lastCor"
QT_MOC_LITERAL(10, 80, 4), // "stop"
QT_MOC_LITERAL(11, 85, 11) // "timeTrigger"

    },
    "TransSmoother\0posUpdate\0\0QGeoCoordinate\0"
    "cor\0start\0interval\0dist\0bearing\0lastCor\0"
    "stop\0timeTrigger"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_TransSmoother[] = {

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
       1,    1,   34,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    4,   37,    2, 0x0a /* Public */,
      10,    0,   46,    2, 0x0a /* Public */,
      11,    0,   47,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, 0x80000000 | 3,    4,

 // slots: parameters
    QMetaType::Void, QMetaType::Int, QMetaType::Double, QMetaType::Double, 0x80000000 | 3,    6,    7,    8,    9,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void TransSmoother::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<TransSmoother *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->posUpdate((*reinterpret_cast< QGeoCoordinate(*)>(_a[1]))); break;
        case 1: _t->start((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< double(*)>(_a[2])),(*reinterpret_cast< double(*)>(_a[3])),(*reinterpret_cast< QGeoCoordinate(*)>(_a[4]))); break;
        case 2: _t->stop(); break;
        case 3: _t->timeTrigger(); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
            }
            break;
        case 1:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 3:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QGeoCoordinate >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (TransSmoother::*)(QGeoCoordinate );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TransSmoother::posUpdate)) {
                *result = 0;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject TransSmoother::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_TransSmoother.data,
    qt_meta_data_TransSmoother,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *TransSmoother::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *TransSmoother::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_TransSmoother.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int TransSmoother::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
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
void TransSmoother::posUpdate(QGeoCoordinate _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE