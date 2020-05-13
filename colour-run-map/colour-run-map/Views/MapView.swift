//
//  MapView.swift
//  colourRun
//
//  Created by Luke on 07/05/2020.
//  Copyright © 2020 Mapway. All rights reserved.
//

import SwiftUI
import MapKit

 public enum MapState {
    case showUserLocation
    case showRoute(_ coordinates: [CLLocationCoordinate2D])
    case showCompleteRoute(_ locations: [CLLocation])
}

struct MapView: UIViewRepresentable {
    
    @State var showsUserLocation = true
    @State var isUserInteractionEnabled = true
    @State var mapState: MapState
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = showsUserLocation
        uiView.isUserInteractionEnabled = isUserInteractionEnabled
        updateUIView(uiView, forState: self.mapState)
    }
    
    private func updateUIView(_ uiView: MKMapView, forState mapState: MapState) {
        switch mapState {
        case .showUserLocation:
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: uiView.userLocation.coordinate, span: span)
            uiView.setRegion(region, animated: true)
        case .showRoute(let coordinates):
            if coordinates.count == 0 {
                if showsUserLocation {
                    let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                    let region = MKCoordinateRegion(center: uiView.userLocation.coordinate, span: span)
                    uiView.setRegion(region, animated: true)
                }
            }
            else if coordinates.count == 1 {
                let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                let region = MKCoordinateRegion(center: coordinates[0], span: span)
                uiView.setRegion(region, animated: true)
            } else {
                uiView.addOverlay(MKPolyline(coordinates: coordinates, count: coordinates.count))
            }
            
            if let lastCoordinate = coordinates.last {
                let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                let region = MKCoordinateRegion(center: lastCoordinate, span: span)
                uiView.setRegion(region, animated: true)
            }
        case .showCompleteRoute(let locations):
            uiView.addOverlay(GradientPolyline(locations: locations))
        }
    }
    
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is GradientPolyline {
            let gradientRender = GradientPolylineRenderer(overlay: overlay)
            gradientRender.lineWidth = 9
            return gradientRender
        } else {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.red.withAlphaComponent(0.8)
            renderer.lineWidth = 9
            return renderer
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(mapState: .showUserLocation)
            .edgesIgnoringSafeArea(.all)
    }
}
