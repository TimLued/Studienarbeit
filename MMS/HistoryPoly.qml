import QtQuick 2.12
import QtPositioning 5.13
import QtLocation 5.13

MapPolyline{
    id: poly
    line.width: 1
    property variant mPath
    property variant center: map.center
    property int zoom: Math.round(map.zoomLevel)

    onZoomChanged: if(poly.visible && !map.isCenterOnAll) optimizePath()
    onCenterChanged: if(poly.visible && !map.isCenterOnAll) optimizePath()
    onMPathChanged: if(poly.visible) optimizePath()


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


    function optimizePath(){
        poly.path = []
        var nPath = optimizeZoom(onViewPoly(mPath))
        poly.path = nPath
    }


    function optimizeZoom(oPath){
        var nPath = []

        //azimuth 5 mit zoomlevel

        var indexList = []
        var step = (21 - Math.round(map.zoomLevel)) * 10 //20-0
        var tmp
        for (var i = 0; i<oPath.length; i++){
            if(i>0 && i<oPath.length-1){
                if (Math.abs(oPath[i-1].azimuthTo(oPath[i])-oPath[i].azimuthTo(oPath[i+1]))>2){
                    indexList.push(i)

                    if(indexList.length===2){ //Anfang-Ende Paar


                        nPath.push(oPath[indexList[0]])

                        //fill in between with density according zoom level
//                        for (var j = indexList[0]+1; j < indexList[1];j++){
//                            if (j%step === 0){
//                                nPath.push(oPath[j])
//                            }
//                        }

                        tmp = indexList[1]
                        nPath.push(oPath[tmp])
                        indexList=[]
                        indexList.push(tmp) //new start
                    }
                }

                //Mindestanzahl?
                //so viele nehmen bis azimouth = 5

            }else{
                nPath.push(oPath[i])
            }
        }

        if (indexList.length === 1){//last corner to actual position
            nPath.push(oPath[indexList[0]])
            for (var k = indexList[0]+1; k < indexList[1];k++){
                if (k%step === 0){
                    nPath.push(oPath[k])
                }
            }
            nPath.push(oPath[oPath.length-1])
        }

        return nPath
    }

    function onViewPoly(oPath){ //keep
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
}
