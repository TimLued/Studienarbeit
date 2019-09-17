function formatDistance(meters)
{
    var dist = Math.round(meters)
    if (dist > 1000 ){
        if (dist > 100000){
            dist = Math.round(dist / 1000)
        }
        else{
            dist = Math.round(dist / 100)
            dist = dist / 10
        }
        dist = dist + "km"
    }
    else{
        dist = dist + "m"
    }
    return dist
}


function rad2degr(rad){
    return rad*180/Math.PI
}

function degr2rad(deg){
    return deg*Math.PI/180
}

function roundNumber(number, digits){
//    var multiple = Math.pow(10, digits);
//    return Math.round(number * multiple) / multiple;
    return number.toFixed(digits)
}

function getLatLngCenter(latLngInDegr) {
    var LATIDX = 0;
    var LNGIDX = 1;
    var sumX = 0;
    var sumY = 0;
    var sumZ = 0;

    for (var i=0; i<latLngInDegr.length; i++) {
        var lat = degr2rad(latLngInDegr[i].latitude);
        var lng = degr2rad(latLngInDegr[i].longitude);
        // sum of cartesian coordinates
        sumX += Math.cos(lat) * Math.cos(lng);
        sumY += Math.cos(lat) * Math.sin(lng);
        sumZ += Math.sin(lat);
    }

    var avgX = sumX / latLngInDegr.length;
    var avgY = sumY / latLngInDegr.length;
    var avgZ = sumZ / latLngInDegr.length;

    // convert average x, y, z coordinate to latitude and longtitude
    lng = Math.atan2(avgY, avgX);
    var hyp = Math.sqrt(avgX * avgX + avgY * avgY);
    lat = Math.atan2(avgZ, hyp);

    return ([rad2degr(lat), rad2degr(lng)]);
}

function is_point_on_screen(point,mapX,mapY,mapW,mapH) {
    if (point.x >= 0 && point.x <= (mapX + mapW)
            && point.y >=0 && point.y <= (mapY + mapH) )
        return true;
    else
        return false;
}


function xcoord2xpos(x, xmin, xmax, width) {
    // Convert X-coordinate to pixel X-position on screen.
    return Math.round((x - xmin) * (width / (xmax - xmin)));
}

function ycoord2ypos(y, ymin, ymax, height) {
    // Convert Y-coordinate to pixel Y-position on screen.
    ymin = ycoord2ymercator(ymin);
    ymax = ycoord2ymercator(ymax);
    return Math.round((ymax - ycoord2ymercator(y)) * (height / (ymax - ymin)));
}


function calcColumnWidths(model, parent)
{
    var maxWidth = 0
    for (var i = 0; i < model.length; ++i)
    {
        var key = model[i]
        var textElement = Qt.createQmlObject(
                    'import QtQuick 2.12;'
                    + 'Text {'
                    + ' text: "' + key+ '" '
                    + '}',
                    parent, "calcColumnWidths")
        maxWidth = Math.max(textElement.width, maxWidth)
        textElement.destroy()
    }

    return maxWidth
}

function calcTxtWidth(txt,parent){
    var mWidth = 0
    var textElement = Qt.createQmlObject(
                'import QtQuick 2.12;'
                + 'Text {'
                + 'text:"' + txt+ '";'
                + 'font.pixelSize:' + parent.font.pixelSize
                + '}',
                parent, "calcTxtWidth")
    mWidth = textElement.width
    textElement.destroy()
    return mWidth
}


function optimizeZoom(oPath){
    var nPath = []

    //azimuth 5 mit zoomlevel

    var indexList = []
    var step = (21 - Math.round(map.zoomLevel)) * 10 //20-0
    var tmp,first,second
    for (var i = 0; i<oPath.length; i++){
        if(i>0 && i<oPath.length-1){
            first = oPath[i-1].azimuthTo(oPath[i])
            second = oPath[i].azimuthTo(oPath[i+1])
            if (Math.abs(first-second)>1 && first!==0 && second!==0){
                nPath.push(oPath[i])

//                    indexList.push(i)
//                    if(indexList.length===2){ //Anfang-Ende Paar
//                        nPath.push(oPath[indexList[0]])
//                        //fill in between with density according zoom level
//                        for (var j = indexList[0]+1; j < indexList[1];j++){
//                            if (j%step === 0){
//                                nPath.push(oPath[j])
//                            }
//                        }
//                        tmp = indexList[1]
//                        nPath.push(oPath[tmp])
//                        indexList=[]
//                        indexList.push(tmp) //new start
//                    }

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

function onViewPoly(oPath){
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

function sliceList(infoList,shortList){
    return infoList.slice(infoList.lastIndexOf(shortList[shortList.length-1])+1,infoList.length)
}

