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
    
    @Binding var selectedAnnotation: ActivityAnnotation?
    var polylineType: GradientPolyline.type
    
    var mapState: MapState
    var recordedLocations: [CLLocation]?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let map = MKMapView(frame: .zero)
        map.delegate = context.coordinator
        map.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Pin")
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
        var milestoneAnnotation = ActivityAnnotation()
        milestoneAnnotation.segment = [CLLocation]()
        
        locations.enumerated().forEach( { index, location in
            //start pin
            guard index != 0 else {
                let start = ActivityAnnotation()
                start.coordinate = location.coordinate
                start.title = "Start"
                map.addAnnotation(start)
                return
            }
            
            milestoneAnnotation.segment?.append(location)
            totalDistance = totalDistance + location.distance(from: locations[index - 1])
            
            if index == locations.count - 1 {
                milestoneAnnotation.coordinate = location.coordinate
                milestoneAnnotation.title = "End"
                milestoneAnnotation.subtitle = locations.last!.timestamp.timeIntervalSince(locations[0].timestamp).asString
                map.addAnnotation(milestoneAnnotation)
                milestoneAnnotation = ActivityAnnotation()
                milestoneAnnotation.segment = [CLLocation]()
                
            } else if totalDistance >= milestone {
                milestoneAnnotation.coordinate = location.coordinate
                milestoneAnnotation.title = milestone.mwKilometersRoundedDown0dp
                milestoneAnnotation.subtitle = location.timestamp.timeIntervalSince(locations[0].timestamp).asString
                map.addAnnotation(milestoneAnnotation)
                milestoneAnnotation = ActivityAnnotation()
                milestoneAnnotation.segment = [CLLocation]()
                milestone = milestone + 1000
            }
        })
        
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
        uiView.removeOverlays(uiView.overlays)
        guard let locations = recordedLocations else { return }
        uiView.addOverlay(GradientPolyline(locations: locations, type: polylineType))
        addMilestonePins(map: uiView, locations: locations)
        let region = MKCoordinateRegion.enclosingRegion(locations: locations)
        uiView.setRegion(region, animated: true)
    }
    
    private func showActivityRow(_ uiView: MKMapView) {
        uiView.showsUserLocation = false
        uiView.isUserInteractionEnabled = false
        uiView.removeOverlays(uiView.overlays)
        guard let locations = recordedLocations else { return }
        uiView.addOverlay(GradientPolyline(locations: locations, type: polylineType))
        let region = MKCoordinateRegion.enclosingRegion(locations: locations)
        uiView.setRegion(region, animated: true)
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let activityAnnotation = annotation as? ActivityAnnotation,
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin", for: activityAnnotation) as? MKMarkerAnnotationView {
            view.annotation = activityAnnotation
            view.glyphImage = UIImage(systemName: "flag")
            if annotation.title == "Start" {
                view.markerTintColor = #colorLiteral(red: 0.3411764801, green: 0.9618825605, blue: 0.1686274558, alpha: 1)
            } else if annotation.title == "End" {
                view.markerTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            } else {
                view.markerTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? ActivityAnnotation {
            parent.selectedAnnotation = annotation
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotation = view.annotation as? ActivityAnnotation,
            parent.selectedAnnotation == annotation {
            parent.selectedAnnotation = nil
        }
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
        MapView(selectedAnnotation: .constant(nil),
                polylineType: .speed,
                mapState: .showUserLocation,
                recordedLocations: nil)
            .edgesIgnoringSafeArea(.all)
    }
}
