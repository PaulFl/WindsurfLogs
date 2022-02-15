//
//  Extensions.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocationCoordinate2D: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(longitude)
        try container.encode(latitude)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let longitude = try container.decode(CLLocationDegrees.self)
        let latitude = try container.decode(CLLocationDegrees.self)
        self.init(latitude: latitude, longitude: longitude)
    }
}


extension MKCoordinateSpan: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(latitudeDelta)
        try container.encode(longitudeDelta)
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let latitudeDelta = try container.decode(CLLocationDegrees.self)
        let longitudeDelta = try container.decode(CLLocationDegrees.self)
        self.init(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
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

