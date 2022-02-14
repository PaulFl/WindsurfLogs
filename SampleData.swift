//
//  SampleData.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import Foundation
import CoreLocation
import MapKit

let sampleTrackPoints = [CLLocationWrapper(location: CLLocation(latitude: 37.334_900, longitude: -122.009_020))]

//let sampleTrack1 = Track(startDate: Date(timeIntervalSinceNow: TimeInterval(-3000)), endDate: Date(), maxSpeed: Speed(speedMS: 10), totalDistance: 11.5*1000, totalDuration: TimeInterval(3000), placemarkName: "La Baule", trackPoints: sampleTrackPoints, middlePoint: sampleTrackPoints.first!)

let sampleTrack1 = Track(trackData: sampleTrackPoints)

let sampleCoordinateRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.334_900,
                                   longitude: -122.009_020),
    latitudinalMeters: 750,
    longitudinalMeters: 750
)

let sampleTrackStore = [sampleTrack1, sampleTrack1]
