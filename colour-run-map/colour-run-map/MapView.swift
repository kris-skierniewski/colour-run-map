//
//  MapView.swift
//  colourRun
//
//  Created by Luke on 07/05/2020.
//  Copyright © 2020 Mapway. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    //var map = MKMapView()
    
    //var currentLocation: CLLocation?
    var recordedLocations: [CLLocation]?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let coordinates = recordedLocations?.compactMap({ $0.coordinate }) {
            uiView.addOverlay(MKPolyline(coordinates: coordinates, count: coordinates.count))
        }
        
        if let location = recordedLocations?.last {
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                       let region = MKCoordinateRegion(center: location.coordinate, span: span)
                       uiView.setRegion(region, animated: true)
        }
        
        
        
        
    }
    
}

extension MapView {
    
//    func zoom(to location: CLLocation?) {
//        if let location = location {
//            let span = MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
//            map.setRegion(region, animated: true)
//        }
//    }
    
    //func showUserLocation() { map.showsUserLocation = true }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        view.canShowCallout = true
        return view
    }
    
//    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
//        mapView.showsUserLocation = true
//        parent.zoom(to: mapView.userLocation.location)
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.red.withAlphaComponent(0.8)
        return renderer
    }
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapView()
    }
}
