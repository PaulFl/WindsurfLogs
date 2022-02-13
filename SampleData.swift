//
//  SampleData.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import Foundation
import CoreLocation

let sampleTrack1 = Track(startDate: Date(timeIntervalSinceNow: TimeInterval(-3000)), endDate: Date(), maxSpeed: Speed(speedMS: 10), totalDistance: 11.11*1000, totalDuration: TimeInterval(3000), placemarkName: "La Baule")
