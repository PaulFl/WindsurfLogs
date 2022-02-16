//
//  OverallStatsView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import SwiftUI

struct OverallStatsView: View {
    @State var showingDeleteAlert = false
    @ObservedObject var sharedTracksStore = TrackStore.shared
    
    var body: some View {
        List {
            Section("All time") {
                Label(title: {
                    let maxSpeed = sharedTracksStore.getOverallMaxSpeed()
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
                    let totalDistance = sharedTracksStore.getOverallDistance()
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
                    Text("\(sharedTracksStore.tracks.count) tracks")
                }, icon: {
                    Image(systemName: "sum")
                })
            }
            
            Section("Reset") {
                Button("Delete all tracks", role: .destructive, action: {
                    showingDeleteAlert = true
                })
            }
        }
        .navigationTitle("Stats")
        .alert("Delete all tracks ?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: {
                TrackStore.shared.tracks.removeAll()
                TrackStore.shared.save(completion: {result in})
            })
        }
    }
}

struct OverallStatsView_Previews: PreviewProvider {
    static var previews: some View {
        OverallStatsView()
    }
}
