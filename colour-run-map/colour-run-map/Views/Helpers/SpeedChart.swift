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
    
    var activity: Activity
    
    private func generateBar(segment: Activity.Segement) -> VerticalProgressBar {
        let slowest = activity.segments.sorted(by: {$0.pace > $1.pace}).last!.pace
        let percentage = slowest / segment.pace
        
        return VerticalProgressBar(width: 10,
                                   height: 200,
                                   color: .green,
                                   value: CGFloat(percentage),
                                   text: "\(segment.index + 1)")
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(activity.segments) { segment in
                self.generateBar(segment: segment)
            }
        }
    }
}

struct PaceChart_Previews: PreviewProvider {
    static var previews: some View {
        SpeedChart(activity: MockHelper.mockActivity)
    }
}
