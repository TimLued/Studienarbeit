/****************************************************************************
** Meta object code from reading C++ file 'tasklist.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../TaskReceiver/tasklist.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'tasklist.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_TaskList_t {
    QByteArrayData data[10];
    char stringdata0[115];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_TaskList_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_TaskList_t qt_meta_stringdata_TaskList = {
    {
QT_MOC_LITERAL(0, 0, 8), // "TaskList"
QT_MOC_LITERAL(1, 9, 15), // "preTaskAppended"
QT_MOC_LITERAL(2, 25, 0), // ""
QT_MOC_LITERAL(3, 26, 16), // "postTaskAppended"
QT_MOC_LITERAL(4, 43, 14), // "preTaskRemoved"
QT_MOC_LITERAL(5, 58, 5), // "index"
QT_MOC_LITERAL(6, 64, 15), // "postTaskRemoved"
QT_MOC_LITERAL(7, 80, 10), // "appendTask"
QT_MOC_LITERAL(8, 91, 4), // "data"
QT_MOC_LITERAL(9, 96, 18) // "removeFinishedTask"

    },
    "TaskList\0preTaskAppended\0\0postTaskAppended\0"
    "preTaskRemoved\0index\0postTaskRemoved\0"
    "appendTask\0data\0removeFinishedTask"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_TaskList[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       4,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   44,    2, 0x06 /* Public */,
       3,    0,   45,    2, 0x06 /* Public */,
       4,    1,   46,    2, 0x06 /* Public */,
       6,    0,   49,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       7,    1,   50,    2, 0x0a /* Public */,
       9,    0,   53,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,    5,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,    8,
    QMetaType::Void,

       0        // eod
};

void TaskList::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<TaskList *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->preTaskAppended(); break;
        case 1: _t->postTaskAppended(); break;
        case 2: _t->preTaskRemoved((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 3: _t->postTaskRemoved(); break;
        case 4: _t->appendTask((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 5: _t->removeFinishedTask(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (TaskList::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TaskList::preTaskAppended)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (TaskList::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TaskList::postTaskAppended)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (TaskList::*)(int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TaskList::preTaskRemoved)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (TaskList::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&TaskList::postTaskRemoved)) {
                *result = 3;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject TaskList::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_TaskList.data,
    qt_meta_data_TaskList,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *TaskList::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *TaskList::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_TaskList.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int TaskList::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void TaskList::preTaskAppended()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void TaskList::postTaskAppended()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void TaskList::preTaskRemoved(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void TaskList::postTaskRemoved()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
