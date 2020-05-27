//
//  PaceChart.swift
//  colour-run-map
//
//  Created by Luke on 26/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct SpeedChart: View {
    
    var segments: [Activity.Segement]
    var highlightedSegment: Activity.Segement?
    
    private func generateBar(segment: Activity.Segement) -> VerticalProgressBar {
        let slowest = segments.sorted(by: {$0.pace > $1.pace}).last!.pace
        
        return VerticalProgressBar(width: 10,
                                   height: 100,
                                   color: segment == highlightedSegment ? .red : .green,
                                   value: CGFloat(slowest / segment.pace),
                                   text: "\(segment.index + 1)")
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(segments) { segment in
                self.generateBar(segment: segment)
            }
        }
    }
}

struct PaceChart_Previews: PreviewProvider {
    static var previews: some View {
        SpeedChart(segments: MockHelper.mockActivity.segments, highlightedSegment: nil)
    }
}
