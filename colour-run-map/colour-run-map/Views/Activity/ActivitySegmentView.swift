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
    
    var segmentPaceVsAveragePace: Double {
        guard let segments = annotation.segment else { return 0.0 }
        let averagePace = PaceHelper.calculatePace(forLocations: activity.locations)
        let segmentPace = PaceHelper.calculatePace(forLocations: segments)
        
        return averagePace / segmentPace
    }
    
    var paceProgressColor: Color {
        let pace = segmentPaceVsAveragePace
        
        if pace >= 1 { return Color.blue }
        else if pace >= 0.9 { return Color.green }
        else if pace >= 0.75 { return Color.yellow }
        else if pace >= 0.5 { return Color.orange }
        
        return Color.red
    }
    
    var body: some View {
        VStack{
            if annotation.segment != nil {
                VStack(spacing: 20){
                    VStack {
                        Text("\(annotation.title!) Split")
                            .font(.title).bold()
                            .padding()
                    }
                    VStack(alignment: .leading) {
//                        Text("Pace: \(PaceHelper.calculatePace(distance: DistanceHelper.sumOfDistances(betweenLocations: annotation.segment!), start: annotation.segment!.first!.timestamp, end: annotation.segment!.last!.timestamp).asString) min/km")
//
//                        Text("Pace Average: \(PaceHelper.calculatePace(forLocations: activity.locations).asString) min/km")
                        
                        HStack {
                            CircularProgressBar(color: paceProgressColor,
                                                diameter: 50,
                                                lineWidth: 5,
                                                clockwise: true,
                                                showPercentage: true,
                                                showBackground: true,
                                                progress: .constant(segmentPaceVsAveragePace))
                            Text("of your average pace")
                        }
                        
                        HStack(alignment: .bottom) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                PaceChart(activity: self.activity)
                            }
                            
                        }
                    }
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
