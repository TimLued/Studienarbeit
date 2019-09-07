import QtQuick 2.12
import QtPositioning 5.13
import QtLocation 5.13
import "algos.js" as Algos

MapPolyline{
    id: poly
    property variant mPath
    property variant simplePath
    onMPathChanged: {
        simplePath = Algos.simplifyPath(mPath)
    }
    onSimplePathChanged: {
        var nPath = []
        for (var i = 0; i<simplePath.length;i++){
            if(simplePath[i]){
                nPath.push(QtPositioning.coordinate(simplePath[i][0],simplePath[i][1]))
            }
        }
        if(nPath.length>0) poly.path = nPath
    }
}
