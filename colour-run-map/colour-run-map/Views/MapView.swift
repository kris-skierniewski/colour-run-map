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
    case showUserLocation
    case showActivityRow
    case showActivityDetail
    case showRecordingActivity
}

struct MapView: UIViewRepresentable {
    
    @State private var showsUserLocation = true
    @State private var isUserInteractionEnabled = true
    
    var mapState: MapState
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
        updateUIView(uiView, forState: mapState)
    }
    
    private func updateUIView(_ uiView: MKMapView, forState mapState: MapState) {
        switch mapState {
        case .showUserLocation: showUserLocation(uiView)
        case .showRecordingActivity: showRecordingActivity(uiView)
        case .showActivityDetail: showActivityDetail(uiView)
        case .showActivityRow: showActivityRow(uiView)
        }
    }
    
    
    // MARK: - Helpers
    private func addMilestonePins(map: MKMapView, locations: [CLLocation]) {
        var totalDistance: CLLocationDistance = 0
        var milestone: CLLocationDistance = 1000
        locations.enumerated().forEach( { index, location in
            guard index != 0 else { return } //ignore first coordinate
            totalDistance = totalDistance + location.distance(from: locations[index - 1])
            
            if totalDistance >= milestone {
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                annotation.title = milestone.mwKilometersRoundedDown0dp
                map.addAnnotation(annotation)
                milestone = milestone + 1000
            }
        })
        
        let start = MKPointAnnotation()
        start.coordinate = locations.first!.coordinate
        start.title = "Start"
        map.addAnnotation(start)
        
        let end = MKPointAnnotation()
        end.coordinate = locations.last!.coordinate
        end.title = "End"
        map.addAnnotation(end)
        
    }
    
    private func showUserLocation(_ uiView: MKMapView) {
        uiView.showsUserLocation = true
        uiView.isUserInteractionEnabled = true
        uiView.removeOverlays(uiView.overlays)
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
    }
    
    private func showRecordingActivity(_ uiView: MKMapView) {
        uiView.showsUserLocation = true
        uiView.isUserInteractionEnabled = true
        if let coordinates = recordedLocations?.compactMap({ $0.coordinate }) {
            uiView.addOverlay(MKPolyline(coordinates: coordinates, count: coordinates.count))
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: coordinates.last ?? uiView.userLocation.coordinate, span: span)
            uiView.setRegion(region, animated: true)
        }
    }
    
    private func showActivityDetail(_ uiView: MKMapView) {
        uiView.showsUserLocation = false
        uiView.isUserInteractionEnabled = true
        guard let locations = recordedLocations else { return }
        uiView.addOverlay(GradientPolyline(locations: locations))
        addMilestonePins(map: uiView, locations: locations)
        let region = MKCoordinateRegion.enclosingRegion(locations: locations)
        uiView.setRegion(region, animated: true)
    }
    
    private func showActivityRow(_ uiView: MKMapView) {
        uiView.showsUserLocation = false
        uiView.isUserInteractionEnabled = false
        guard let locations = recordedLocations else { return }
        uiView.addOverlay(GradientPolyline(locations: locations))
        let region = MKCoordinateRegion.enclosingRegion(locations: locations)
        uiView.setRegion(region, animated: true)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
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
        MapView(mapState: .showUserLocation, recordedLocations: nil)
            .edgesIgnoringSafeArea(.all)
    }
}
