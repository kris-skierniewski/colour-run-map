//
//  ActivityDetailView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 13/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ActivityDetailView: View {
    
    var activity: Activity
    
    @State private var selectedAnnotation: ActivityAnnotation?
    @State private var polylineType: GradientPolyline.type = .speed
    @State private var cardHeight: CGFloat = 200
    @State private var isHidden: Bool = false
    
    var body: some View {
        VStack{
            ZStack {
                MapView(selectedAnnotation: $selectedAnnotation,
                        polylineType: polylineType,
                        mapState: .showActivityDetail,
                        recordedLocations: activity.locations)
                    .edgesIgnoringSafeArea(.all)
                if selectedAnnotation != nil {
                    CardView(height: $cardHeight) {
                        ActivitySegmentView(annotation: selectedAnnotation!)
                    }
                }
                
                RecordingHeadBar(recordedLocations: activity.locations)
            }
        }
        .navigationBarItems(trailing:
            Picker(selection: $polylineType, label: Text("Line type")) {
                Text("Speed").tag(GradientPolyline.type.speed)
                Text("Altitude").tag(GradientPolyline.type.altitude)
            }.pickerStyle(SegmentedPickerStyle())
        )
        
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let mockActivity = Activity.init(context: context)
        mockActivity.createdAt = Date()
        mockActivity.locations = [CLLocation(latitude: 36.063457, longitude: -95.880516),
                                  CLLocation(latitude: 36.063457, longitude: -95.980516)]
        
        return NavigationView{ ActivityDetailView(activity: mockActivity) }
            
    }
}


