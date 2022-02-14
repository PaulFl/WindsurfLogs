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
    

    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: TrackStore.shared.tracks) {
            MapMarker(coordinate: $0.middlePoint.location.coordinate, tint: .accentColor)
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
