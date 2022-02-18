//
//  WindsurfLogsApp.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import SwiftUI

@main
struct WindsurfLogsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
//                    print(NSHomeDirectory())
                    TrackStore.shared.load(completion: {result in
                        print(result)
                        if case .failure(let error) = result {
                            print(error)
                            TrackStore.shared.tracks = []
                            TrackStore.shared.save(completion: {result in })
                        }
                    })
                }
                .onOpenURL(perform: {url in
                    do {
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
                                if !TrackStore.shared.tracks.contains(newTrack) {
                                    DispatchQueue.main.async {
                                        Task {
                                            await newTrack.setPlacemark()
                                            TrackStore.shared.tracks.append(newTrack)
                                            TrackStore.shared.tracks.sort()
                                            TrackStore.shared.save(completion: {result in
                                                print("\(TrackStore.shared.tracks.count) tracks saved")
                                                                    if case .failure(let error) = result {
                                                                        print(error.localizedDescription)
                                                                    }
                                                                })
                                        }
                                    }
                                }
                            }
                        }
                    } catch {
                        print(error)
                    }
                })
        }
    }
}
