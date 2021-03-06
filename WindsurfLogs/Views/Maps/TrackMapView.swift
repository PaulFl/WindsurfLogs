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
    @Binding var lineCoordinates: [CLLocationCoordinate2D]?
    
    var body: some View {
        UIMapView(region: mapRegion, mapType: .standard, interactionEnabled: false, lineCoordinates: lineCoordinates ?? [])
    }
}

struct TrackMapView_Previews: PreviewProvider {
    static var previews: some View {
        TrackMapView(mapRegion: sampleCoordinateRegion, lineCoordinates: .constant([]))
    }
}
