import QtQuick 2.12
import QtPositioning 5.13
import QtLocation 5.13

MapPolyline{
    id: poly
    line.width: 1
    property variant mPath
    //property variant sPath
    property variant center: map.center
    property int zoom: Math.round(map.zoomLevel)

//    onZoomChanged: if(poly.visible) updatePoly()
//    onCenterChanged: if(poly.visible) poly.path = onviewPoly(sPath)
//    onMPathChanged: if(poly.visible) {
//                        sPath = doublePoly(mPath)
//                        updatePoly()
//                    }

//    function updatePoly(){
//        var nPoly = scalePoly(sPath)
//        poly.path = onviewPoly(nPoly)
//    }

    onZoomChanged: if(poly.visible) poly.path = optimize(mPath)
    onCenterChanged: if(poly.visible) poly.path = optimize(mPath)
    onMPathChanged: if(poly.visible) poly.path = optimize(mPath)


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


    function optimize(oPath){
        var nPath = []
        var step = (21 - Math.round(map.zoomLevel)) * 10 //20-0
        for (var j = 0; j<oPath.length; j++){
            if (j%step === 0){//scaling
                nPath.push(oPath[j])
            }else if(j>0 && j<oPath.length-1){//still add if corner
                if (Math.abs(oPath[j-1].azimuthTo(oPath[j])-oPath[j].azimuthTo(oPath[j+1]))>5){
                    nPath.push(oPath[j])
                }
            }
        }
        if ((oPath.length-1)%(step+1) != 0) nPath.push(oPath[oPath.length-1]) //add last coordinate thus connecting to dynamic
        return onviewPoly(nPath)
    }

    function onviewPoly(oPath){ //keep
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



    function doublePoly(oPath){ //ev raus?
        var doublePath = []
        for (var j = 0; j<oPath.length; j++){
            if(doublePath.indexOf(oPath[j])===-1) doublePath.push(oPath[j])
        }
        return doublePath
    }

    function scalePoly(oPath){//Ecken drin behalten!!!
        var scaledPath = []
        var step = (21 - Math.round(map.zoomLevel)) * 8 //20-0
        for (var i = 0; i<oPath.length; i+=step+1){
            scaledPath.push(oPath[i])
        }
        if ((oPath.length-1)%(step+1) != 0) scaledPath.push(oPath[oPath.length-1])
        return scaledPath
    }

    //max Beschränkung

}
