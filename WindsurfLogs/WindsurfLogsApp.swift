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
                    TrackStore.shared.load(completion: {result in
                        if case .failure(let error) = result {
                            print(error)
                            TrackStore.shared.tracks = []
                            TrackStore.shared.save(completion: {result in })
                        }
                    })
                }
        }
    }
}
