//
//  MapListView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 14/02/2022.
//

import SwiftUI
import MapKit

struct MapListView: View {
    @State var mapRegion: MKCoordinateRegion
    @ObservedObject var sharedTracksStore = TrackStore.shared


    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: $sharedTracksStore.tracks) { $track in
            MapAnnotation(coordinate: track.middlePoint.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                NavigationLink(destination: TrackDetailsView(track: $track)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
        }
            .edgesIgnoringSafeArea(.top)
    }
}

struct MapListView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            NavigationView {
                MapListView(mapRegion: sampleCoordinateRegion)
            }
            .tabItem({
                Image(systemName: "map")
            })
        }
    }
}
