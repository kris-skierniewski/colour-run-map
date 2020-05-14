//
//  MapView.swift
//  colourRun
//
//  Created by Luke on 07/05/2020.
//  Copyright © 2020 Mapway. All rights reserved.
//

import SwiftUI
import MapKit

public enum MapState: Equatable {
    case other
    case showUserLocation
    case showRoute(_ coordinates: [CLLocationCoordinate2D])
    case showCompleteRoute(_ locations: [CLLocation])
    
    static public func == (lhs: MapState, rhs: MapState) -> Bool {
        switch (lhs, rhs) {
        case (.other, .other),
             (.showUserLocation, .showUserLocation):
          return true
        default:
          return false
        }
    }
}

struct MapView: UIViewRepresentable {
    
    @State var showsUserLocation = true
    @State var isUserInteractionEnabled = true
    @Binding var mapState: MapState
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, state: mapState)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = showsUserLocation
        uiView.isUserInteractionEnabled = isUserInteractionEnabled
        updateUIView(uiView, forState: mapState)
    }
    
    private func updateUIView(_ uiView: MKMapView, forState mapState: MapState) {
        switch mapState {
        case .showUserLocation:
            if let userLocation = uiView.userLocation.location {
                let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
                uiView.setRegion(region, animated: true)
            } else {
                LocationManager.shared.getLocation(withCompletion: { userLocation in
                    guard let userLocation = userLocation else { return }
                    let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                    let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
                    uiView.setRegion(region, animated: true)
                })
            }
            
        case .showRoute(let coordinates):
            uiView.addOverlay(MKPolyline(coordinates: coordinates, count: coordinates.count))

            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: uiView.userLocation.coordinate, span: span)
            uiView.setRegion(region, animated: true)
            
        case .showCompleteRoute(let locations):
            uiView.addOverlay(GradientPolyline(locations: locations))
            if isUserInteractionEnabled {
                addMilestonePins(map: uiView, locations: locations)
            }
            let region = MKCoordinateRegion.enclosingRegion(locations: locations)
            uiView.setRegion(region, animated: true)
        case .other:
            break
        }
    }
    
    func addMilestonePins(map: MKMapView, locations: [CLLocation]) {
        var totalDistance: CLLocationDistance = 0
        var milestone: CLLocationDistance = 1000
        locations.enumerated().forEach( { index, location in
            guard index != 0 else { return } //ignore first coordinate
            totalDistance = totalDistance + location.distance(from: locations[index - 1])
            
            if totalDistance >= milestone {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = milestone.stringWithUnitsRounded
                map.addAnnotation(annotation)
                milestone = milestone + 1000
            }
        })
    }

    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    var mapViewState: MapState

    init(_ parent: MapView, state: MapState) {
        self.parent = parent
        self.mapViewState = state
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
//        view.canShowCallout = true
//        return view
//    }
    
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
        MapView(mapState: Binding.constant(.showUserLocation))
            .edgesIgnoringSafeArea(.all)
    }
}
