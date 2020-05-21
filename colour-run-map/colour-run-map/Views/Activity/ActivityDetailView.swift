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
    
    @State var selected: ActivityAnnotation?
    
    @State var polylineType: GradientPolyline.type = .speed
    
    var body: some View {
        VStack{
            ZStack {
                MapView(selected: $selected,
                        polylineType: polylineType,
                        mapState: .showActivityDetail,
                        recordedLocations: activity.locations)
                    .edgesIgnoringSafeArea(.all)
                CardView(height: 300) {
                    if selected != nil {
                        ActivitySegmentView(annotation: selected!)
                    } else {
                        Text("Nothing selected")
                    }
                }
            }
        }.navigationBarItems(trailing:
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
        mockActivity.duration = .minuteInSeconds
        mockActivity.distance = .kilometerInMeters
        
        return ActivityDetailView(activity: mockActivity,
                                  selected: ActivityAnnotation(),
                                  polylineType: .speed)
    }
}


