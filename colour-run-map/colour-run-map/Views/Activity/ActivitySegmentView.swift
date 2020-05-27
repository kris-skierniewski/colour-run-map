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
    @Binding var annotation: ActivityAnnotation?
    var activity: Activity
    
    var body: some View {
        VStack{
            if annotation?.segment != nil {
                VStack{
                    VStack {
                        Text("\(annotation!.title!) Split")
                            .font(.title).bold()
                    }
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading) {
                            ActivitySegmentView_Pace(annotation: $annotation, activity: activity)
                            ActivitySegmentView_Speed(annotation: $annotation, activity: activity)
                        }.padding(.all)
                    }.frame(height: 250)
                }
                
            }
        }
    }
}



struct ActivitySegmentView_Previews: PreviewProvider {
    static var previews: some View {
        return ActivitySegmentView(annotation: .constant(MockHelper.mockAnnotation),
                                   activity: MockHelper.mockActivity)
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}



fileprivate struct ActivitySegmentView_Speed: View {
    
    @Binding var annotation: ActivityAnnotation?
    @State var activity: Activity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Speed")
                .font(.title)
            if annotation != nil {
                HStack(alignment: .bottom) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        SpeedChart(segments: getSubArray(startIndex: max(0, annotation!.segment!.index - 6),
                                                         endIndex: min(activity.segments.count, annotation!.segment!.index + 6),
                                                         inclusive: min(activity.segments.count, annotation!.segment!.index + 6) == annotation!.segment!.index + 6),
                                   highlightedSegment: annotation!.segment)
                    }
                    
                }
            }
        }
    }
    
    func getSubArray(startIndex: Int, endIndex: Int, inclusive: Bool = true) -> [Activity.Segement] {
        return inclusive ? Array(activity.segments[min(startIndex, endIndex) ... max(startIndex, endIndex)])
            : Array(activity.segments[min(startIndex, endIndex) ..< max(startIndex, endIndex)])
    }
}

fileprivate struct ActivitySegmentView_Pace: View {
    @Binding var annotation: ActivityAnnotation?
    @State var activity: Activity
    
    var segmentPaceVsAveragePace: Double {
        guard let segmentLocations = annotation?.segment?.locations else { return 0.0 }
        let averagePace = PaceHelper.calculatePace(forLocations: activity.locations)
        let segmentPace = PaceHelper.calculatePace(forLocations: segmentLocations)
        
        return averagePace / segmentPace
    }
    
    var paceProgressColor: Color {
        let pace = segmentPaceVsAveragePace
        
        if pace >= 1 { return Color.red }
        else if pace >= 0.9 { return Color.orange }
        else if pace >= 0.75 { return Color.yellow }
        else if pace >= 0.5 { return Color.green }
        
        return Color.blue
    }
    
    var body: some View {
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
    }
}
