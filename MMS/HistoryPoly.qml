import QtQuick 2.12
import QtPositioning 5.13
import QtLocation 5.13

MapPolyline{
    id: poly
    line.width: 1
    property variant mPath
    property variant sPath
    property variant center: map.center
    property int zoom: Math.round(map.zoomLevel)

    onZoomChanged: if(poly.visible) updatePoly()
    onCenterChanged: if(poly.visible) poly.path = onviewPoly(sPath)
    onMPathChanged: if(poly.visible) {
                        sPath = doublePoly(mPath)
                        updatePoly()
                    }

    function updatePoly(){
        var nPoly = scalePoly(sPath)
        poly.path = onviewPoly(nPoly)
    }

    function maxCheck(){
        /*Wenn größer Differenz rausschmeißen
        Zb 1200
        Diff 200
        1200/200
        6 abrunden!
        Jeden 6. Raus
        Max Value?
        */
    }

    function doublePoly(oPath){
        var doublePath = []
        for (var j = 0; j<oPath.length; j++){
            if(doublePath.indexOf(oPath[j])===-1) doublePath.push(oPath[j])
        }
        return doublePath
    }

    function scalePoly(oPath){
        var scaledPath = []
        var step = (21 - Math.round(map.zoomLevel)) * 8 //20-0
        for (var i = 0; i<oPath.length; i+=step+1){
            scaledPath.push(oPath[i])
        }
        if ((oPath.length-1)%(step+1) != 0) scaledPath.push(oPath[oPath.length-1])
        return scaledPath
    }

    function onviewPoly(oPath){
        var visiblePath = []

        var topleft = map.toCoordinate(Qt.point(0,0))
        var bottomright = map.toCoordinate(Qt.point(win.width,win.height))

        var rect = QtPositioning.rectangle(topleft,bottomright)
        var counter = 0
        var inside = false
        for (var i = 0; i<oPath.length;i++){
            if (rect.contains(oPath[i])) {
                visiblePath.push(oPath[i])
                if (!inside) counter++
                inside = true
            }else{
                if (inside) counter++
                inside = false
            }
        }
        if(counter <= 1) {
            return visiblePath
        }else{
            return oPath
        }
    }

    //max Beschränkung

}
