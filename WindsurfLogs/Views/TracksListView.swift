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
    @State var progress = 2.0
    @ObservedObject var sharedTracksStore = TrackStore.shared
    
    var body: some View {
        
        List {
            ForEach($sharedTracksStore.tracks, id: \.startDate) {$track in
                NavigationLink(destination: TrackDetailsView(track: $track)) {
                    TrackRowView(track: $track)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle("Tracks")
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                if progress > 1.5 {
                    Button(action: {
                        if !TrackStore.shared.isLoading {
                            presentImporter = true
                        }
                    }) {
                        if TrackStore.shared.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.accentColor))
                        } else {
                            Image(systemName: "plus")
                        }
                    }
                } else {
                    ProgressView(value: progress)
                        .frame(width: 50)
                }
            }
        }
        .fileImporter(isPresented: $presentImporter, allowedContentTypes: [UTType("com.paulfly.SBP") ?? .data], allowsMultipleSelection: true, onCompletion: {result in
            DispatchQueue.global(qos: .userInteractive).async {
                do {
                    let results = try result.get()
                    for (i, url) in results.enumerated() {
                        DispatchQueue.main.async {
                            progress = Double(i)/Double(results.count-1)
                        }
                        
                        if url.startAccessingSecurityScopedResource() {
                            let data = try Data(contentsOf: url)
                            url.stopAccessingSecurityScopedResource()
                            let waypoints = SBPDataToWaypoints(fileData: data)
                            let decodedWaypoints = decodeWaypoints(waypoints: waypoints)
                            var newTracks = [Track]()
                            for trackData in decodedWaypoints {
                                newTracks.append(Track(trackData: trackData, fileName: url.lastPathComponent))
                            }
                            for newTrack in newTracks {
                                if !sharedTracksStore.tracks.contains(newTrack) {
                                    DispatchQueue.main.async {
                                        Task {
                                            await newTrack.setPlacemark()
                                            sharedTracksStore.tracks.append(newTrack)
                                            sharedTracksStore.tracks.sort()
                                            sharedTracksStore.save(completion: {result in
                                                if case .failure(let error) = result {
                                                    print(error.localizedDescription)
                                                }
                                            })
                                        }
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        progress = 2.0
                    }
                } catch {
                    DispatchQueue.main.async {
                        progress = 2.0
                    }
                    print(error)
                    return
                }
            }
        })
    }
    
    func delete(at offsets: IndexSet) {
        sharedTracksStore.tracks.remove(atOffsets: offsets)
        TrackStore.shared.save(completion: {result in})
    }
}

struct TracksListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TracksListView()
        }
    }
}

