//
//  OverallStatsView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import SwiftUI

struct OverallStatsView: View {
    var body: some View {
        List {
            Section("All time") {
                Label(title: {
                    let maxSpeed = getOverallMaxSpeed()
                    HStack {
                        Text(maxSpeed.getFormattedSpeedKPH())
                        Spacer()
                        Text(maxSpeed.getFormattedSpeedKTS())
                            .foregroundColor(.secondary)
                    }
                }, icon: {
                    Image(systemName: "speedometer")
                })
                
                Label(title: {
                    let totalDistance = getOverallDistance()
                    HStack {
                        Text(totalDistance.getFormattedKM())
                        Spacer()
                        Text(totalDistance.getFormattedNautic())
                            .foregroundColor(.secondary)
                    }
                }, icon: {
                    Image(systemName: "point.3.connected.trianglepath.dotted")
                })
                
                Label(title: {
                    Text("\(TrackStore.shared.tracks.count) tracks")
                }, icon: {
                    Image(systemName: "sum")
                })
            }
        }
        .navigationTitle("Stats")
    }
}

struct OverallStatsView_Previews: PreviewProvider {
    static var previews: some View {
        OverallStatsView()
    }
}
