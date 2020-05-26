//
//  ActivityDetailView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 13/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

public enum DataSet: Int {
    case speed = 0
    case altitude = 1
    
    var asString: String {
        switch self {
        case .speed: return "Speed"
        case .altitude: return "Altitude"
        }
    }
    
    var icon: Image {
        switch self {
        case .speed: return Image(systemName: "speedometer")
        case .altitude: return Image(systemName: "airplane")
        }
    }
    
    var polylineType: GradientPolyline.type {
        switch self {
        case .speed: return .speed
        case .altitude: return .altitude
        }
    }
}

struct ActivityDetailView: View {
    
    var activity: Activity
    
    @State private var selectedAnnotation: ActivityAnnotation?
    @State private var polylineType: DataSet = .speed
    @State private var isHidden: Bool = false
    @State private var bottomCardOffset: CGFloat = 450
    
    var body: some View {
        VStack{
            ZStack {
                MapView(selectedAnnotation: $selectedAnnotation,
                        polylineType: polylineType.polylineType,
                        mapState: .showActivityDetail,
                        recordedLocations: activity.locations)
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    VStack {
                        Spacer().frame(height: 60)
                        RecordingHeadBar(recordedLocations: activity.locations)
                        HStack {
                            Spacer().frame(height: 10)
                            DataSetSelector(selectedState: $polylineType)
                            Spacer()
                        }
                        Spacer()
                    }.edgesIgnoringSafeArea(.all)
                    
                    if selectedAnnotation != nil {
                        BottomCardContainer(bottomCardHeightOffset: selectedAnnotation != nil ? $bottomCardOffset : .constant(screenSize.height)) {
                            ActivitySegmentView(selectedAnnotation: selectedAnnotation!, activity: activity)
                        }
                    }
                }
                
                
            }
        }
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
