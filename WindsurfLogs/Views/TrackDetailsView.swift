//
//  TrackDetailsView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 13/02/2022.
//

import SwiftUI

struct TrackDetailsView: View {
    let track: Track
    
    var body: some View {
            List {
                // MARK: Date & time
                Section("Date & Time") {
                    // MARK: Calendar
                    Label(title: {
                        Text(track.startDate.formatted(date: .complete, time: .omitted))
                    }, icon: {
                        Image(systemName: "calendar")
                            .foregroundColor(.accentColor)
                    })
                    // MARK: Time
                    Label(title: {
                        HStack {
                            Text(track.startDate.formatted(date: .omitted, time: .shortened))
                                .multilineTextAlignment(.trailing)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.secondary)
                            Text(track.endDate.formatted(date: .omitted, time: .shortened))
                        }
                    }, icon: {
                        Image(systemName: "clock")
                            .foregroundColor(.accentColor)
                    })
                    // MARK: Duration
                    Label(title: {
                        Text(track.getFormattedDuration())
                    }, icon: {
                        Image(systemName: "hourglass")
                            .foregroundColor(.accentColor)
                    })
                }
                
                // MARK: Speed & Distance
                Section("Speed & Distance") {
                    // MARK: Max speed
                    NavigationLink(destination: EmptyView()) {
                        Label(title: {
                            HStack(spacing: 0) {
                                Text(track.maxSpeed.getFormattedSpeedKPH())
                                Spacer()
                                Text(track.maxSpeed.getFormattedSpeedKTS())
                                    .foregroundColor(.secondary)
                                    .padding(.trailing)
                            }
                        }, icon: {
                            Image(systemName: "speedometer")
                                .foregroundColor(.accentColor)
                    })
                    }
                    // MARK: Distance
                    Label(title: {
                        HStack {
                            Text(track.getFormattedTotalDistanceKM())
                            Spacer()
                            Text(track.getFormattedTotalDistanceNautic())
                                .foregroundColor(.secondary)
                                .padding(.trailing)
                        }
                    }, icon: {
                        Image(systemName: "point.3.connected.trianglepath.dotted")
                            .foregroundColor(.accentColor)
                    })
                }
                
                // MARK: Map
                Section("Map") {
                    NavigationLink(destination: EmptyView()) {
                        TrackMapView()
                            .cornerRadius(4)
                            .frame(minHeight: UIScreen.main.bounds.height / 2)
                    }

                }
            }
            .listStyle(.sidebar)
            .navigationTitle(track.placemarkName ?? "Track details")
    }
}

struct TrackDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrackDetailsView(track: sampleTrack1)
        }
    }
}