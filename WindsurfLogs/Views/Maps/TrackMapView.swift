//
//  TrackMapView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 14/02/2022.
//

import SwiftUI
import MapKit

struct TrackMapView: View {
    @State var mapRegion: MKCoordinateRegion
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, interactionModes: [])
    }
}

struct TrackMapView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMapView(mapRegion: sampleCoordinateRegion)
    }
}
