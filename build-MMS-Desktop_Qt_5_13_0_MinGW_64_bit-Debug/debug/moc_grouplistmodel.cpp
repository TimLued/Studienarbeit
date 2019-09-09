/****************************************************************************
** Meta object code from reading C++ file 'grouplistmodel.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../MMS/grouplistmodel.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'grouplistmodel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_GroupListModel_t {
    QByteArrayData data[15];
    char stringdata0[147];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_GroupListModel_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_GroupListModel_t qt_meta_stringdata_GroupListModel = {
    {
QT_MOC_LITERAL(0, 0, 14), // "GroupListModel"
QT_MOC_LITERAL(1, 15, 11), // "createGroup"
QT_MOC_LITERAL(2, 27, 0), // ""
QT_MOC_LITERAL(3, 28, 11), // "deleteGroup"
QT_MOC_LITERAL(4, 40, 2), // "id"
QT_MOC_LITERAL(5, 43, 13), // "setGroupColor"
QT_MOC_LITERAL(6, 57, 5), // "color"
QT_MOC_LITERAL(7, 63, 10), // "setGroupId"
QT_MOC_LITERAL(8, 74, 5), // "newId"
QT_MOC_LITERAL(9, 80, 9), // "addMember"
QT_MOC_LITERAL(10, 90, 6), // "member"
QT_MOC_LITERAL(11, 97, 14), // "containsMember"
QT_MOC_LITERAL(12, 112, 12), // "removeMember"
QT_MOC_LITERAL(13, 125, 13), // "setVisibility"
QT_MOC_LITERAL(14, 139, 7) // "visible"

    },
    "GroupListModel\0createGroup\0\0deleteGroup\0"
    "id\0setGroupColor\0color\0setGroupId\0"
    "newId\0addMember\0member\0containsMember\0"
    "removeMember\0setVisibility\0visible"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_GroupListModel[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    0,   54,    2, 0x02 /* Public */,
       3,    1,   55,    2, 0x02 /* Public */,
       5,    2,   58,    2, 0x02 /* Public */,
       7,    2,   63,    2, 0x02 /* Public */,
       9,    2,   68,    2, 0x02 /* Public */,
      11,    2,   73,    2, 0x02 /* Public */,
      12,    2,   78,    2, 0x02 /* Public */,
      13,    2,   83,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    4,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    4,    6,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    4,    8,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,    4,   10,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString,    4,   10,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,    4,   10,
    QMetaType::Void, QMetaType::QString, QMetaType::Bool,    4,   14,

       0        // eod
};

void GroupListModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<GroupListModel *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->createGroup(); break;
        case 1: _t->deleteGroup((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 2: _t->setGroupColor((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 3: _t->setGroupId((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 4: { bool _r = _t->addMember((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 5: { bool _r = _t->containsMember((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 6: _t->removeMember((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< QString(*)>(_a[2]))); break;
        case 7: _t->setVisibility((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject GroupListModel::staticMetaObject = { {
    &QAbstractListModel::staticMetaObject,
    qt_meta_stringdata_GroupListModel.data,
    qt_meta_data_GroupListModel,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *GroupListModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *GroupListModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_GroupListModel.stringdata0))
        return static_cast<void*>(this);
    return QAbstractListModel::qt_metacast(_clname);
}

int GroupListModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QAbstractListModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
