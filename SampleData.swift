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

let sampleTrack1 = Track(trackData: sampleTrackPoints, fileName: "20200906_Cruas_103L_5.7_4.7.sbp")

let sampleCoordinateRegion = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 46.227638,
                                   longitude: 2.213749),
    latitudinalMeters: 1000000,
    longitudinalMeters: 1000000
)

let sampleTrackStore = [sampleTrack1, sampleTrack1]

let sampleSplitSpeeds = [
    CLLocationDistance(500): [SegmentSpeed(distance: 501, duration: 10.4), SegmentSpeed(distance: 504, duration: 12)],
    CLLocationDistance(200): [SegmentSpeed(distance: 201, duration: 5), SegmentSpeed(distance: 205, duration: 6.2)]
]
