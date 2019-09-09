#ifndef GROUP_H
#define GROUP_H

#include <QQmlContext>

class Group{

public:
    QString id() const{
        return mId;
    }
    void sedId(const QString &id){
        mId = id;
    }

    QString color() const{
        return mColor;
    }

    void setColor(QString color){
        mColor = color;
    }

    QVariantList members() const{
        return mMembers;
    }

    void addMember(QString id){
        mMembers.append(id);
    }

    void removeMember(QString id){
        mMembers.removeOne(id);
    }

    bool visible() const{
        return mVisible;
    }

    void setVisible(bool visible){
        mVisible = visible;
    }



private:
    QString mId;
    QString mColor;
    QVariantList mMembers;
    bool mVisible = true;

};

#endif // GROUP_H
