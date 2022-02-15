//
//  Track.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import Foundation
import CoreLocation
import MapKit


class Track: Codable, Comparable, ObservableObject, Identifiable {
    let startDate: Date
    let endDate: Date
    
    let maxSpeed: Speed
    let totalDistance: CLLocationDistance
    let totalDuration: TimeInterval
    
    @Published var placemarkName: String?
    
    let startPoint: CLLocationWrapper
    let middlePoint: CLLocationWrapper
    let trackSpan: MKCoordinateSpan
    
    @Published var trackPoints: [CLLocationCoordinate2D]?
    
    
    enum CodingKeys: CodingKey {
        case startDate, endDate, maxSpeed, totalDistance, totalDuration, placemarkName, middlePoint, startPoint, trackSpan, trackPoints
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        maxSpeed = try container.decode(Speed.self, forKey: .maxSpeed)
        totalDistance = try container.decode(CLLocationDistance.self, forKey: .totalDistance)
        totalDuration = try container.decode(TimeInterval.self, forKey: .totalDuration)
        placemarkName = try container.decode(String.self, forKey: .placemarkName)
        startPoint = try container.decode(CLLocationWrapper.self, forKey: .startPoint)
        middlePoint = try container.decode(CLLocationWrapper.self, forKey: .middlePoint)
        trackSpan = try container.decode(MKCoordinateSpan.self, forKey: .trackSpan)
//        trackPoints = try container.decode([CLLocationCoordinate2D].self, forKey: .trackPoints)
        trackPoints = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(maxSpeed, forKey: .maxSpeed)
        try container.encode(totalDistance, forKey: .totalDistance)
        try container.encode(totalDuration, forKey: .totalDuration)
        try container.encode(placemarkName, forKey: .placemarkName)
        try container.encode(startPoint, forKey: .startPoint)
        try container.encode(middlePoint, forKey: .middlePoint)
        try container.encode(trackSpan, forKey: .trackSpan)
        try container.encode(trackPoints, forKey: .trackPoints)
    }
    
    init(trackData: [CLLocationWrapper]) {
        self.placemarkName = "Track name"

        self.startDate = trackData.first?.location.timestamp ?? Date()
        self.endDate = trackData.last?.location.timestamp ?? Date()
        
        self.maxSpeed = Speed(speedMS: maxSpeedInstant(waypoints: trackData))
        self.totalDistance = WindsurfLogs.totalDistance(waypoints: trackData)
        self.totalDuration = WindsurfLogs.totalDuration(waypoints: trackData).duration


        
//        let (_, furthestPointFromStart) = furthestPointDistanceFromStart(waypoints: trackData)
        self.trackPoints = trackData.map{$0.location.coordinate}
        
        let trackRegion = getTrackMapRegion(waypoints: trackData)
        self.startPoint = trackData.first!
        self.middlePoint = CLLocationWrapper(location: CLLocation(latitude: trackRegion.center.latitude, longitude: trackRegion.center.longitude))
        self.trackSpan = trackRegion.span
        
        
        
        Task {
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.reverseGeocodeLocation(self.startPoint.location)
            if let placemark = placemarks.first {
                print(placemark)
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
            let placemarksMiddle = try await geocoder.reverseGeocodeLocation(self.middlePoint.location)
            if let placemarkMiddle = placemarksMiddle.first {
                if placemarkMiddle.inlandWater != nil {
                    self.placemarkName = placemarkMiddle.inlandWater
                }
            }
            TrackStore.shared.save(completion: {result in})
        }
        saveTrackData(startDate: self.startPoint.location.timestamp, trackData: self.trackPoints ?? [])
    }
    
    static func == (lhs: Track, rhs: Track) -> Bool {
        return lhs.startDate == rhs.startDate
    }
    
    static func < (lhs: Track, rhs: Track) -> Bool {
        return lhs.startDate > rhs.startDate
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
