//
//  MapPinLocation.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 14/02/2022.
//

import Foundation
import CoreLocation

struct MapPinLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
