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
    var multiple = Math.pow(10, digits);
    return Math.round(number * multiple) / multiple;
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
                + ' text: "' + txt+ '" '
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


var Line = function( p1, p2 ) {
    this.p1 = p1;
    this.p2 = p2;

    this.distanceToPoint = function( point ) {
        // slope
        var m = ( this.p2[0] - this.p1[0]  ) / ( this.p2[1]  - this.p1[1]  ),
        // y offset
        b = this.p1[0]  - ( m * this.p1[1]  ),
        d = [];
        // distance to the linear equation
        d.push( Math.abs( point[0]  - ( m * point[1]  ) - b ) / Math.sqrt( Math.pow( m, 2 ) + 1 ) );
        // distance to p1
        d.push( Math.sqrt( Math.pow( ( point[1] - this.p1[1] ), 2 ) + Math.pow( ( point[0]  - this.p1[0]  ), 2 ) ) );
        // distance to p2
        d.push( Math.sqrt( Math.pow( ( point[1] - this.p2[1] ), 2 ) + Math.pow( ( point[0]  - this.p2[0]  ), 2 ) ) );
        // return the smallest distance
        return d.sort( function( a, b ) {
            return ( a - b ); //causes an array to be sorted numerically and ascending
        } )[0];
    };
};


var simplify = function(points, tolerance) {
    var douglasPeucker = function( points, tolerance ) {
        if ( points.length <= 2 ) {
            return [points[0]];
        }
        var returnPoints = [],
        // make line from start to end
        line = new Line( points[0], points[points.length - 1] ),
        // find the largest distance from intermediate poitns to this line
        maxDistance = 0,
        maxDistanceIndex = 0,
        p;
        for( var i = 1; i <= points.length - 2; i++ ) {
            var distance = line.distanceToPoint( points[ i ] );
            if( distance > maxDistance ) {
                maxDistance = distance;
                maxDistanceIndex = i;
            }
        }
        // check if the max distance is greater than our tollerance allows
        if ( maxDistance >= tolerance ) {
            p = points[maxDistanceIndex];
            line.distanceToPoint( p, true );
            // include this point in the output
            returnPoints = returnPoints.concat( douglasPeucker( points.slice( 0, maxDistanceIndex + 1 ), tolerance ) );
            // returnPoints.push( points[maxDistanceIndex] );
            returnPoints = returnPoints.concat( douglasPeucker( points.slice( maxDistanceIndex, points.length ), tolerance ) );
        } else {
            // ditching this point
            p = points[maxDistanceIndex];
            line.distanceToPoint( p, true );
            returnPoints = [points[0]];
        }
        return returnPoints;
    }
    var result = douglasPeucker( points, tolerance );
    // always have to push the very last point on so it doesn't get left off
    result.push( points[points.length - 1 ] );
    return result;
};

function simplifyPath(points) {
    var toleranceInDegrees = metersToDegrees(100); // value from slider
    var simple = simplify(convertToArrayOfArray(points), toleranceInDegrees)
    return(simple);
}

function metersToDegrees(meters) { // this is approximate (spherical earth, average circumference, not considering altitude, etc.)
    var earth = 40075000; // average circumference in metres at sea level
    return meters * 360.0 / earth;
}

// Converts [{lat,lng},...,{lat,lng}] to [[0][1],...,[0][1]]
function convertToArrayOfArray(sourceArray) {
    var destArray = [];
    for(var i = 0; i < sourceArray.length; i++) {
        destArray.push([sourceArray[i].latitude, sourceArray[i].longitude]);
    }
    return destArray;
}

