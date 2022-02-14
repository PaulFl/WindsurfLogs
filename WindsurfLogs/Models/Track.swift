//
//  Track.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import Foundation
import CoreLocation
import MapKit


class Track: Codable, Comparable {
    let startDate: Date
    let endDate: Date
    
    let maxSpeed: Speed
    let totalDistance: CLLocationDistance
    let totalDuration: TimeInterval
    
    var placemarkName: String?
    
    let trackPoints: [CLLocationWrapper]
    let middlePoint: CLLocationWrapper
    
    init(trackData: [CLLocationWrapper]) {
        self.placemarkName = "Track name"

        self.startDate = trackData.first?.location.timestamp ?? Date()
        self.endDate = trackData.last?.location.timestamp ?? Date()
        
        self.maxSpeed = Speed(speedMS: maxSpeedInstant(waypoints: trackData))
        self.totalDistance = WindsurfLogs.totalDistance(waypoints: trackData)
        self.totalDuration = WindsurfLogs.totalDuration(waypoints: trackData).duration

        self.trackPoints = trackData

        
        let (_, furthestPointFromStart) = furthestPointDistanceFromStart(waypoints: trackData)
        
        self.middlePoint = middlePointLocation(waypoint1: trackData.first!, waypoint2: furthestPointFromStart)
        
        Task {
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.reverseGeocodeLocation(self.middlePoint.location)
            if let placemark = placemarks.first {
                if placemark.inlandWater != nil {
                    self.placemarkName = placemark.inlandWater
                } else if placemark.areasOfInterest?.first != nil {
                    self.placemarkName = placemark.areasOfInterest!.first
                } else if placemark.locality != nil {
                    self.placemarkName = placemark.locality
                } else if placemark.ocean != nil {
                    self.placemarkName = placemark.ocean
                }
            }
        }
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate
    }
    
    static func < (lhs: Track, rhs: Track) -> Bool {
        return lhs.startDate < rhs.startDate
    }
    
    func getFormattedDuration() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self.totalDuration) ?? "-"
    }
    
    func getFormattedTotalDistanceKM() -> String {
        let distance = totalDistance * 0.001
        return String(format: "%.2f km", distance)
    }
    
    func getFormattedTotalDistanceNautic() -> String {
        let distance = totalDistance * 0.000539957
        return String(format: "%.2f nm", distance)
    }
}

public struct CLLocationWrapper: Codable {
    var location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    public enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case altitude
        case horizontalAccuracy
        case verticalAccuracy
        case speed
        case course
        case timestamp
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(location.coordinate.latitude, forKey: .latitude)
        try container.encode(location.coordinate.longitude, forKey: .longitude)
        try container.encode(location.altitude, forKey: .altitude)
        try container.encode(location.horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(location.verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(location.speed, forKey: .speed)
        try container.encode(location.course, forKey: .course)
        try container.encode(location.timestamp, forKey: .timestamp)
    }

    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        let altitude = try container.decode(CLLocationDistance.self, forKey: .altitude)
        let horizontalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .horizontalAccuracy)
        let verticalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .verticalAccuracy)
        let speed = try container.decode(CLLocationSpeed.self, forKey: .speed)
        let course = try container.decode(CLLocationDirection.self, forKey: .course)
        let timestamp = try container.decode(Date.self, forKey: .timestamp)
        
        let location = CLLocation(coordinate: CLLocationCoordinate2DMake(latitude, longitude), altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy, course: course, speed: speed, timestamp: timestamp)
        
        self.init(location: location)
    }
}

//extension CLLocation: Encodable {
//    public enum CodingKeys: String, CodingKey {
//        case latitude
//        case longitude
//        case altitude
//        case horizontalAccuracy
//        case verticalAccuracy
//        case speed
//        case course
//        case timestamp
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(coordinate.latitude, forKey: .latitude)
//        try container.encode(coordinate.longitude, forKey: .longitude)
//        try container.encode(altitude, forKey: .altitude)
//        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
//        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
//        try container.encode(speed, forKey: .speed)
//        try container.encode(course, forKey: .course)
//        try container.encode(timestamp, forKey: .timestamp)
//    }
//}
