//
//  UIMapView.swift
//  WindsurfLogs
//
//  Created by Paul Fleury on 15/02/2022.
//

import SwiftUI
import MapKit

struct UIMapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let mapType: MKMapType
    let interactionEnabled: Bool
    let lineCoordinates: [CLLocationCoordinate2D]
    
    // Create the MKMapView using UIKit.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = mapType
        mapView.delegate = context.coordinator
        mapView.region = region
        if !interactionEnabled {
            mapView.isScrollEnabled = false
        }
        mapView.isRotateEnabled = false
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.mapType = mapType
    }
    
    // Link it to the coordinator which is defined below.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: UIMapView
    
    init(_ parent: UIMapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.purple
            renderer.lineWidth = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
}
