//
//  ActivitySegmentView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 19/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ActivitySegmentView: View {
    private var annotation: ActivityAnnotation
    private let isStart: Bool
    private let isEnd: Bool
    private let activity: Activity
    
    init(selectedAnnotation: ActivityAnnotation, isStart: Bool = false, isEnd: Bool = false, activity: Activity) {
        self.annotation = selectedAnnotation
        self.isStart = isStart
        self.isEnd = isEnd
        self.activity = activity
    }
    
    var body: some View {
        VStack{
            if annotation.segment != nil {
                VStack{
                    Text("\(annotation.title!) Split")
                        .font(.title).bold()
                        .padding()
                    Text("Pace: \(PaceHelper.calculatePace(distance: DistanceHelper.sumOfDistances(betweenLocations: annotation.segment!), start: annotation.segment!.first!.timestamp, end: annotation.segment!.last!.timestamp).asString) min/km")
                }
            }
        }
    }
}

struct ActivitySegmentView_Previews: PreviewProvider {
    static var previews: some View {
        return ActivitySegmentView(selectedAnnotation: MockHelper.mockAnnotation,
                                   isStart: false,
                                   isEnd: false,
                                   activity: MockHelper.mockActivity)
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
