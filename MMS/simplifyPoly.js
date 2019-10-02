WorkerScript.onMessage = function(msg) {
    var toleranceInDegrees = metersToDegrees(36);
    var corArray = convertToArrayOfArray(msg.req)
    var simpleArray = simplify(corArray, toleranceInDegrees)
    var simple = convertToLatLon(simpleArray)
    WorkerScript.sendMessage({'reply':simple});
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

function convertToLatLon(sourceArray) {
    var destArray = [];
    for(var i = 0; i < sourceArray.length; i++) {
        destArray.push({'latitude':sourceArray[i][0],'longitude':sourceArray[i][1]})
    }
    return destArray;
}
