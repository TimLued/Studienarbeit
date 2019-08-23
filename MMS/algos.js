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



