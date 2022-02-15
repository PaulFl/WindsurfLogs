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
