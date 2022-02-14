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
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, interactionModes: [])
            
            .aspectRatio(1.0, contentMode: .fit)
    }
}

struct MiniMapView_Previews: PreviewProvider {
    static var previews: some View {
        MiniMapView(mapRegion: sampleCoordinateRegion)
    }
}
