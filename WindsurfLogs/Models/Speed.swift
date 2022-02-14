//
//  Speed.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import Foundation

struct Speed: Codable, Comparable {
    let speedMS: Double
    let speedKPH: Double
    let speedKTS: Double
    
    init(speedMS: Double) {
        self.speedMS = speedMS
        self.speedKPH = speedMS * 3.6
        self.speedKTS = speedMS * 1.94384
    }
    
    static func < (lhs: Speed, rhs: Speed) -> Bool {
        return lhs.speedMS < rhs.speedMS
    }
    
    func getFormattedSpeedKPH() -> String {
        return String(format: "%.2f km/h", self.speedKPH)
    }
    
    func getFormattedSpeedKTS() -> String {
        return String(format: "%.2f kts", self.speedKTS)
    }
}
