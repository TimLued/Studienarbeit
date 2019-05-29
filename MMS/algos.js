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
        dist = dist + " km"
    }
    else{
        dist = dist + " m"
    }
    return dist
}


function toDeg(rad){
    return rad*180/Math.PI
}

function toRad(deg){
    return deg*Math.PI/180
}


function calcPos(lat1,lon1,bearing,d){
    lat1 = toRad(lat1)
    lon1 = toRad(lon1)
    bearing = toRad(bearing)

    d = d/6371000 //Earth radius

    var lat2
    var lon2

    //asin( sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(bearing))
    lat2 = Math.asin(Math.sin(lat1)*Math.cos(d) + Math.cos(lat1)*Math.sin(d)*Math.cos(bearing))
    //lon1 + atan2(sin(bearing)*sin(d/R)*cos(lat1), cos(d/R)-sin(lat1)*sin(lat2))
    lon2 = lon1 + Math.atan2(Math.sin(bearing)*Math.sin(d)*Math.cos(lat1),Math.cos(d)-Math.sin(lat1)*Math.sin(lat2))

    lat2 = toDeg(lat2)
    lon2 = toDeg(lon2)

    return [lat2, lon2]
}

function bearing(lat1, lon1, lat2, lon2){
    lat1 = toRad(lat1)
    lon1 = toRad(lon1)

    lat2 = toRad(lat2)
    lon2 = toRad(lon2)
    var y
    var x
    y = Math.sin(lon2-lon1)*Math.cos(lat2)
    x = Math.cos(lat1)*Math.sin(lat2) - Math.sin(lat1)*Math.cos(lat2)*Math.cos(lon2-lon1)

    return toDeg(Math.atan2(y, x))
}

function roundNumber(number, digits){
    var multiple = Math.pow(10, digits);
    return Math.round(number * multiple) / multiple;
}

function pointAngle(x1,y1,x2,y2){
    var angle = Math.atan2(y2-y1,x2-x1)
    angle *= 180/Math.PI
    return angle
}
