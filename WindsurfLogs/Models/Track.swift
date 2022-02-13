//
//  Track.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import Foundation
import CoreLocation
import MapKit


struct Track {
    let startDate: Date
    let endDate: Date
    
    let maxSpeed: Speed
    let totalDistance: CLLocationDistance
    let totalDuration: TimeInterval
    
    let placemarkName: String?
    
    func getFormattedDuration() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        return formatter.string(from: totalDuration) ?? ""
    }
    
    func getFormattedTotalDistance() -> String {
        let formatter = MKDistanceFormatter()
        formatter.units = .metric
        formatter.unitStyle = .abbreviated
        return formatter.string(fromDistance: totalDistance)
    }
}
