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
    case showActivityDetailSegement
    case showRecordingActivity
}

struct MapView: UIViewRepresentable {
    
    @State private var showsUserLocation = true
    @State private var isUserInteractionEnabled = true
    
    @Binding var selectedAnnotation: ActivityAnnotation?
    var polylineType: GradientPolyline.type
    
    var mapState: MapState
    var recordedLocations: [CLLocation]?
    var activity: Activity?
    
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
        case .showActivityDetail, .showActivityDetailSegement: showActivityDetail(uiView)
        case .showActivityRow: showActivityRow(uiView)
        }
    }
    
    // MARK: - Helpers
    private func addMilestonePins(map: MKMapView, activity: Activity) {
        activity.segments.forEach { segment in
            if segment == activity.segments.first {
                let start = ActivityAnnotation(segment: segment, isStart: true)
                start.coordinate = segment.locations.first!.coordinate
                start.title = "Start"
                map.addAnnotation(start)
            }
            
            if segment == activity.segments.last {
                let end = ActivityAnnotation(segment: segment, isEnd: true)
                end.coordinate = end.milestoneCoordinate.coordinate
                end.title = "End"
                map.addAnnotation(end)
            } else {
                let milestoneAnnotation = ActivityAnnotation(segment: segment)
                milestoneAnnotation.coordinate = milestoneAnnotation.milestoneCoordinate.coordinate
                milestoneAnnotation.title = "\(segment.index + 1) km"
                milestoneAnnotation.subtitle = segment.duration.asString
                map.addAnnotation(milestoneAnnotation)
            }
        }
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
        if let coordinates = recordedLocations?.compactMap({ $0.coordinate }),
            let lastLocation = recordedLocations?.last {
            uiView.addOverlay(MKPolyline(coordinates: coordinates, count: coordinates.count))
            uiView.setRegion(MKCoordinateRegion.regionFor(trackingLocation: lastLocation), animated: true)
        }
    }
    
    private func showActivityDetail(_ uiView: MKMapView) {
        uiView.showsUserLocation = false
        uiView.isUserInteractionEnabled = true
        uiView.removeOverlays(uiView.overlays)
        guard let activity = activity else { return }
        uiView.addOverlay(GradientPolyline(locations: activity.locations, type: polylineType))
        addMilestonePins(map: uiView, activity: activity)
        if mapState == .showActivityDetail {
            uiView.setRegion(MKCoordinateRegion.enclosingRegion(locations: activity.locations), animated: true)
        } else if mapState == .showActivityDetailSegement{
            uiView.setRegion(MKCoordinateRegion.regionForActivityDetails(atLocation: selectedAnnotation!.milestoneCoordinate), animated: true)
        }
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
            switch annotation.title {
            case "Start":  view.markerTintColor = #colorLiteral(red: 0.3411764801, green: 0.9618825605, blue: 0.1686274558, alpha: 1)
            case "End": view.markerTintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            default: view.markerTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? ActivityAnnotation {
            parent.selectedAnnotation = annotation
            parent.mapState = .showActivityDetailSegement
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
