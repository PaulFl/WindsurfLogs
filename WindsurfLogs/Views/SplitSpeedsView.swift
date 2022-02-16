//
//  SplitSpeedsView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 16/02/2022.
//

import SwiftUI

struct SplitSpeedsView: View {
    @Binding var track: Track
    
    var body: some View {
        List {
            if track.splitSpeeds != nil {
                ForEach(Array(track.splitSpeeds!.keys).sorted(), id: \.self) {segmentDistance in
                    Section(String(segmentDistance) + " meters") {
                        let len = track.splitSpeeds![segmentDistance]!.count
                        
                        ForEach((0..<len), id: \.self) {i in
                            let segmentSpeed = track.splitSpeeds![segmentDistance]![i]
                            Label(title: {
                                VStack(spacing: 6) {
                                    HStack {
                                        Text(segmentSpeed.speed.getFormattedSpeedKPH())
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        Text(segmentSpeed.speed.getFormattedSpeedKTS())
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    HStack {
                                        Text("\(String(format: "%.2f", segmentSpeed.distance)) meters in \(String(format: "%.2f", segmentSpeed.duration)) s")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }
                            }, icon: {
                                Image(systemName: i == 0 ? "crown" : "\(i+1).circle")
                            })
                        }
                    }
                }
            }
        }
        .navigationTitle(track.placemarkName ?? "Track")
    }
}

struct SplitSpeedsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SplitSpeedsView(track: .constant(sampleTrack1))
        }
    }
}
