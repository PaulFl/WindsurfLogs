//
//  TrackRowView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import SwiftUI

struct TrackRowView: View {
    let track: Track
    
    var body: some View {
        HStack {
            map
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                title
                Spacer()
                date
                times
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
    
    var title: some View {
        Text(track.placemarkName ?? "Track")
            .font(.headline)
    }
    
    var date: some View {
        Text(track.startDate.formatted(date: .abbreviated, time: .omitted))
    }
    
    var times: some View {
        HStack(spacing: 4) {
            Text(track.startDate.formatted(date: .omitted, time: .shortened))
            Image(systemName: "arrow.right")
            Text(track.endDate.formatted(date: .omitted, time: .shortened))
        }
    }
    
    var map: some View {
        MiniMapView(mapRegion: mapRegion(trackPoints: track.trackPoints, spanFactor: 8.0))
            .frame(width: 110)
            .cornerRadius(4)
    }
}

struct TrackRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                NavigationLink(destination: EmptyView()) {
                    TrackRowView(track: sampleTrack1)
                }
            }
        }
    }
}
