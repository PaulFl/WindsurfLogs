//
//  TrackMapFullView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import SwiftUI
import MapKit

struct TrackMapFullView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let track: Track
    @State var selectedMapType = MKMapType.standard

    
    var body: some View {
        let span = MKCoordinateSpan(latitudeDelta: track.trackSpan.latitudeDelta * 1.2, longitudeDelta: track.trackSpan.longitudeDelta * 1.2)
        let region = MKCoordinateRegion(center: track.middlePoint.location.coordinate, span: span)
        
        ZStack {
            UIMapView(region: region, mapType: selectedMapType, interactionEnabled: true, lineCoordinates: track.trackPoints ?? [])
                .edgesIgnoringSafeArea(horizontalSizeClass == .compact ? .top : .all)
            VStack {
                Spacer()
                Picker("Map type", selection: $selectedMapType) {
                    Text("Standard").tag(MKMapType.standard)
                    Text("Hybrid").tag(MKMapType.hybrid)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.all, 10)
            }
        }
    }
}

struct TrackMapFullView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TrackMapFullView(track: sampleTrack1)
        }
    }
}
