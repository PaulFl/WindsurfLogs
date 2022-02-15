//
//  TrackMapFullView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import SwiftUI
import MapKit

struct TrackMapFullView: View {
    let track: Track
    
    var body: some View {
        let span = MKCoordinateSpan(latitudeDelta: track.trackSpan.latitudeDelta * 1.2, longitudeDelta: track.trackSpan.longitudeDelta * 1.2)
        let region = MKCoordinateRegion(center: track.middlePoint.location.coordinate, span: span)
        UIMapView(region: region, interactionEnabled: true, lineCoordinates: track.trackPoints ?? [])
            .ignoresSafeArea()
    }
}

struct TrackMapFullView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrackMapFullView(track: sampleTrack1)
        }
    }
}
