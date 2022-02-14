//
//  MiniMapView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 11/02/2022.
//

import SwiftUI
import MapKit

struct MiniMapView: View {
    @State var mapRegion: MKCoordinateRegion
    
    let pins: [MapPinLocation]
    
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, interactionModes: [], annotationItems: pins) {
//            MapMarker(coordinate: $0.coordinate, tint: .accentColor)
            MapAnnotation(coordinate: $0.coordinate, anchorPoint: CGPoint(x: 0.5, y: 1)) {
                Image(systemName: "mappin")
                    .foregroundColor(.accentColor)
            }
        }
            .aspectRatio(1.0, contentMode: .fit)
    }
}

struct MiniMapView_Previews: PreviewProvider {
    static var previews: some View {
        MiniMapView(mapRegion: sampleCoordinateRegion, pins: [MapPinLocation(coordinate: sampleCoordinateRegion.center)])
    }
}
