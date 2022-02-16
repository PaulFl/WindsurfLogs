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
    
    let spanFactor = 1.0
    
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

func computeSplitSpeeds(trackPoints: [CLLocationWrapper], splitDistances: [CLLocationDistance]) -> [CLLocationDistance: [SegmentSpeed]] {
    var splitSpeeds = [CLLocationDistance: [SegmentSpeed]]()
    
    var pointToPointDistance = [CLLocationDistance]()
    
    for i in 1..<trackPoints.count {
        pointToPointDistance.append(trackPoints[i].location.distance(from: trackPoints[i-1].location))
    }
    
    // MARK: For each split distance to calcul
    for splitDistance in splitDistances {
        // MARK: Get all segments of specified distance
        var splitSegments = [SplitSegment]()
        
        var currentSegment = SplitSegment(startIndex: 0, endIndex: 0, averageSpeed: 0, totalDistance: 0, totalDuration: 0)
        
        for i in 1..<trackPoints.count {
            currentSegment.endIndex = i
            currentSegment.totalDistance += pointToPointDistance[i-1]
            while currentSegment.totalDistance >= splitDistance {
                currentSegment.totalDuration = trackPoints[currentSegment.endIndex].location.timestamp.timeIntervalSince(trackPoints[currentSegment.startIndex].location.timestamp)
                currentSegment.updateAverageSpeed()
                splitSegments.append(currentSegment)
                currentSegment.startIndex += 1
                currentSegment.totalDistance -= pointToPointDistance[currentSegment.startIndex]
            }
            
        }
        
        splitSegments.sort()
        splitSegments.reverse()
        
        // MARK: Select the fastest 3 non overlapping
        var selectedSplitSegments = [splitSegments.first ?? SplitSegment(startIndex: 0, endIndex: 0, averageSpeed: 0, totalDistance: 0, totalDuration: 0)]
        
        for segment in splitSegments {
            var isSegmentOverlapping = false
            for alreadySelectedSegment in selectedSplitSegments {
                let range = alreadySelectedSegment.startIndex...alreadySelectedSegment.endIndex
                if range.contains(segment.startIndex) || range.contains(segment.endIndex) {
                    isSegmentOverlapping = true
                    break
                }
            }
            if !isSegmentOverlapping {
                selectedSplitSegments.append(segment)
            }
            if selectedSplitSegments.count >= 3 {
                break
            }
        }
        
        // MARK: Build SegmentSpeed array from selected top segments
        var segmentSpeedsForDistance = [SegmentSpeed]()
        for seg in selectedSplitSegments {
            segmentSpeedsForDistance.append(SegmentSpeed(distance: seg.totalDistance, duration: seg.totalDuration))
        }
        splitSpeeds[splitDistance] = segmentSpeedsForDistance
    }
    
    return splitSpeeds
}

struct SplitSegment: Comparable {
    var startIndex: Int
    var endIndex: Int
    var averageSpeed: CLLocationSpeed
    var totalDistance: CLLocationDistance
    var totalDuration: TimeInterval
    
    static func < (lhs: SplitSegment, rhs: SplitSegment) -> Bool {
        return lhs.averageSpeed < rhs.averageSpeed
    }
    
    mutating func updateAverageSpeed() {
        averageSpeed = totalDistance / totalDuration
    }
}
