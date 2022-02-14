//
//  Track.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import Foundation
import CoreLocation
import MapKit


struct Track: Codable, Comparable {
    let startDate: Date
    let endDate: Date
    
    let maxSpeed: Speed
    let totalDistance: CLLocationDistance
    let totalDuration: TimeInterval
    
    let placemarkName: String?
    
    let trackPoints: [CLLocationWrapper]
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate
    }
    
    static func < (lhs: Track, rhs: Track) -> Bool {
        return lhs.startDate < rhs.startDate
    }
    
    func getFormattedDuration() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        return formatter.string(from: totalDuration) ?? ""
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

extension Track {
    init(trackData: [CLLocationWrapper]) {
        self.startDate = trackData.first?.location.timestamp ?? Date()
        self.endDate = trackData.last?.location.timestamp ?? Date()
        
        self.maxSpeed = Speed(speedMS: 0)
        self.totalDistance = CLLocationDistance(0)
        self.totalDuration = TimeInterval(0)
        
        self.placemarkName = "Test"
        self.trackPoints = trackData
    }
}

public struct CLLocationWrapper: Codable {
    var location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CLLocation.CodingKeys.self)
        
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

extension CLLocation: Encodable {
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
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(horizontalAccuracy, forKey: .horizontalAccuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(speed, forKey: .speed)
        try container.encode(course, forKey: .course)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
