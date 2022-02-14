//
//  TrackStore.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 14/02/2022.
//

import Foundation


class TrackStore: ObservableObject {
    static let shared = TrackStore()
    
    @Published var tracks: [Track] = []
    @Published var isLoading = false
    
    private init() {}
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("tracks.data")
    }
    
    func load(completion: @escaping (Result<[Track], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                DispatchQueue.main.async {
                    self.isLoading = true
                }
                let fileURL = try self.fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        self.tracks = []
                        self.isLoading = false
                    }
                    return
                }
                let decodedTracks = try JSONDecoder().decode([Track].self, from: file.availableData)
                DispatchQueue.main.async {
                    self.tracks = decodedTracks
                    self.tracks.sort()
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(.failure(error))
                }
            }
        }
    }
    
    func save(completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(self.tracks)
                let outfile = try self.fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(self.tracks.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
