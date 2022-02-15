//
//  TrackProcessing.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 14/02/2022.
//

import Foundation
import MapKit

public func totalDuration(waypoints: [CLLocationWrapper]) -> DateInterval {
    return DateInterval(start: waypoints.first!.location.timestamp, end: waypoints.last!.location.timestamp)
}

public func maxSpeedInstant(waypoints: [CLLocationWrapper]) -> CLLocationSpeed {
    var maxSpeed = waypoints.first?.location.speed ?? CLLocationSpeed(0)
    
    for wp in waypoints{
        if wp.location.speed > maxSpeed {
            maxSpeed = wp.location.speed
        }
    }
    
    return maxSpeed
}

public func totalDistance(waypoints: [CLLocationWrapper]) -> CLLocationDistance {
    if waypoints.count <= 1 {
        return Double(0)
    }
    
    var distance = CLLocationDistance(0)
    
    var startLocation = waypoints.first!.location
    var endLocation = waypoints.first!.location
    
    for i in 1..<waypoints.count {
        startLocation = endLocation
        endLocation = waypoints[i].location
        
        let dist = endLocation.distance(from: startLocation)
        distance += dist
    }
    return distance
}

public func furthestPointDistanceFromStart(waypoints: [CLLocationWrapper]) -> (distance: CLLocationDistance, point: CLLocationWrapper) {
    var maxTack = CLLocationDistance()
    var furthestPoint = CLLocationWrapper(location: CLLocation())
    
    let startWp = waypoints.first
    if startWp == nil {
        return (maxTack, furthestPoint)
    }
    
    for wp in waypoints {
        let dist = startWp!.location.distance(from: wp.location)
        if dist > maxTack {
            maxTack = dist
            furthestPoint = wp
        }
    }
    
    return (maxTack, furthestPoint)
}

public func getTrackMapRegion(waypoints: [CLLocationWrapper]) -> MKCoordinateRegion {
    if waypoints.first == nil {
        return MKCoordinateRegion()
    }
    
    let spanFactor = 1.6
    
    var maxLat = waypoints.first!.location.coordinate.latitude
    var minLat = waypoints.first!.location.coordinate.latitude
    var maxLon = waypoints.first!.location.coordinate.longitude
    var minLon = waypoints.first!.location.coordinate.longitude
    for wp in waypoints {
        if wp.location.coordinate.latitude > maxLat {
            maxLat = wp.location.coordinate.latitude
        } else if wp.location.coordinate.latitude < minLat {
            minLat = wp.location.coordinate.latitude
        }
        
        if wp.location.coordinate.longitude > maxLon {
            maxLon = wp.location.coordinate.longitude
        } else if wp.location.coordinate.longitude < minLon {
            minLon = wp.location.coordinate.longitude
        }
    }
    
    let middleLat = (minLat + maxLat) / 2
    let middleLon = (minLon + maxLon) / 2
    
    let center = CLLocationCoordinate2D(latitude: middleLat, longitude: middleLon)
    let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*spanFactor, longitudeDelta: (maxLon - minLon)*spanFactor)
    
    return MKCoordinateRegion(center: center, span: span)
}

//public func miniMapRegion(waypoints: [CLLocationWrapper]) -> MKCoordinateRegion {
//    if waypoints.first == nil {
//        return MKCoordinateRegion()
//    }
//    
//    let spanFactor = 8.0
//    
//    var maxLat = waypoints.first!.location.coordinate.latitude
//    var minLat = waypoints.first!.location.coordinate.latitude
//    var maxLon = waypoints.first!.location.coordinate.longitude
//    var minLon = waypoints.first!.location.coordinate.longitude
//    for wp in waypoints {
//        if wp.location.coordinate.latitude > maxLat {
//            maxLat = wp.location.coordinate.latitude
//        } else if wp.location.coordinate.latitude < minLat {
//            minLat = wp.location.coordinate.latitude
//        }
//        
//        if wp.location.coordinate.longitude > maxLon {
//            maxLon = wp.location.coordinate.longitude
//        } else if wp.location.coordinate.longitude < minLon {
//            minLon = wp.location.coordinate.longitude
//        }
//    }
//    
//    let middleLat = (minLat + maxLat) / 2
//    let middleLon = (minLon + maxLon) / 2
//    
//    let center = CLLocationCoordinate2D(latitude: middleLat, longitude: middleLon)
//    let span = MKCoordinateSpan(latitudeDelta: spanFactor, longitudeDelta: spanFactor)
//    
//    return MKCoordinateRegion(center: center, span: span)
//}

public func middlePointLocation(trackPoints: [CLLocationWrapper]) -> CLLocationWrapper {
    if trackPoints.first?.location == nil {
        return CLLocationWrapper(location: CLLocation())
    }
    

    var maxLat = trackPoints.first!.location.coordinate.latitude
    var minLat = trackPoints.first!.location.coordinate.latitude
    var maxLon = trackPoints.first!.location.coordinate.longitude
    var minLon = trackPoints.first!.location.coordinate.longitude
    for point in trackPoints {
        if point.location.coordinate.latitude > maxLat {
            maxLat = point.location.coordinate.latitude
        } else if point.location.coordinate.latitude < minLat {
            minLat = point.location.coordinate.latitude
        }
        
        if point.location.coordinate.longitude > maxLon {
            maxLon = point.location.coordinate.longitude
        } else if point.location.coordinate.longitude < minLon {
            minLon = point.location.coordinate.longitude
        }
    }
    
    let middleLat = (minLat + maxLat) / 2
    let middleLon = (minLon + maxLon) / 2
    
    let center = CLLocationCoordinate2D(latitude: middleLat, longitude: middleLon)
    return CLLocationWrapper(location: CLLocation(latitude: center.latitude, longitude: center.longitude))
}
