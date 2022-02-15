//
//  OverallStats.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import Foundation
import CoreLocation

func getOverallDistance() -> CLLocationDistance {
    var distance = CLLocationDistance(0)
    for track in TrackStore.shared.tracks {
        distance += track.totalDistance
    }
    return distance
}

func getOverallMaxSpeed() -> Speed {
    let speeds = TrackStore.shared.tracks.map {$0.maxSpeed}
    return speeds.max() ?? Speed(speedMS: 0)
}
