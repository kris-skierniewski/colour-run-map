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
        case .altitude: return Image(systemName: "square.stack.3d.up")
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
    
    private var isShowingBottomCard: Binding<Bool> { Binding (
        get: { self.selectedAnnotation != nil },
        set: { if !$0 { self.selectedAnnotation = nil } }
        )
    }
    
    var body: some View {
        ZStack {
            MapView(selectedAnnotation: $selectedAnnotation,
                    polylineType: polylineType.polylineType,
                    mapState: $selectedAnnotation.wrappedValue == nil ? .showActivityDetail : .showActivityDetailSegement,
                    activity: activity)
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                VStack {
                    RecordingHeadBar(recordedLocations: activity.locations)
                        .padding(.top)
                    HStack {
                        Spacer().frame(height: 10)
                        DataSetSelector(selectedState: $polylineType)
                        Spacer()
                    }
                    Spacer()
                }
                
                BottomCardContainer(bottomCardHeightOffset: $bottomCardOffset,
                                    isVisible: isShowingBottomCard) {
                    if selectedAnnotation != nil {
                        ActivitySegmentView(selectedAnnotation: selectedAnnotation!, activity: activity)
                    }
                    
                }
            }
            
            
        }.navigationBarTitle(Text(activity.createdAt.mwFormatted("EEEE dd MMMM")), displayMode: .inline)
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationView{ ActivityDetailView(activity: MockHelper.mockActivity) }
        
    }
}
