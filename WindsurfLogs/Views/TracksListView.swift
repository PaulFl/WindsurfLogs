//
//  TracksListView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 14/02/2022.
//

import SwiftUI
import UniformTypeIdentifiers

struct TracksListView: View {
    @State var presentImporter = false
    
    var body: some View {
        List {
            ForEach(TrackStore.shared.tracks.reversed(), id: \.startDate) {track in
                NavigationLink(destination: TrackDetailsView(track: track)) {
                    TrackRowView(track: track)
                }
            }
        }
        .navigationTitle("Tracks")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {presentImporter = true}) {
                    Image(systemName: "plus")
                }
            }
        }
        .fileImporter(isPresented: $presentImporter, allowedContentTypes: [UTType("com.paulfly.SBP") ?? .data], allowsMultipleSelection: true, onCompletion: {result in
            do {
                let url = try result.get().first!
                let data = try Data(contentsOf: url)
                let waypoints = SBPDataToWaypoints(fileData: data)
                let decodedWaypoints = decodeWaypoints(waypoints: waypoints)
                var newTracks = [Track]()
                for trackData in decodedWaypoints {
                    newTracks.append(Track(trackData: trackData))
                }
                for newTrack in newTracks {
                    if !TrackStore.shared.tracks.contains(newTrack) {
                        TrackStore.shared.tracks.append(newTrack)
                    }
                }
                TrackStore.shared.tracks.sort()

                
            } catch {
                return
            }
        })
    }
}

struct TracksListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TracksListView()
        }
    }
}

