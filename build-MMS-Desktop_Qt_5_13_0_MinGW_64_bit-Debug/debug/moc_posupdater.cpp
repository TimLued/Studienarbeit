/****************************************************************************
** Meta object code from reading C++ file 'posupdater.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../MMS/posupdater.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'posupdater.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_PosUpdater_t {
    QByteArrayData data[8];
    char stringdata0[71];
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
QT_MOC_LITERAL(4, 33, 10), // "requestPos"
QT_MOC_LITERAL(5, 44, 11), // "setTupeName"
QT_MOC_LITERAL(6, 56, 7), // "readPos"
QT_MOC_LITERAL(7, 64, 6) // "update"

    },
    "PosUpdater\0posUpdated\0\0droneInfo\0"
    "requestPos\0setTupeName\0readPos\0update"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_PosUpdater[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   39,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       4,    0,   42,    2, 0x0a /* Public */,
       5,    1,   43,    2, 0x0a /* Public */,
       6,    0,   46,    2, 0x08 /* Private */,
       7,    0,   47,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    3,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    2,
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
        case 0: _t->posUpdated((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 1: _t->requestPos(); break;
        case 2: _t->setTupeName((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 3: _t->readPos(); break;
        case 4: _t->update(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (PosUpdater::*)(QString );
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
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 5;
    }
    return _id;
}

// SIGNAL 0
void PosUpdater::posUpdated(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
