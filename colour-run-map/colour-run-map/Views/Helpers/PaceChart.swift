//
//  PaceChart.swift
//  colour-run-map
//
//  Created by Luke on 26/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct PaceChart: View {
    
    var activity: Activity
    
    private func bar(fastestSegment: Activity.Segement,
                     slowestSegment: Activity.Segement,
                     thisSegment: Activity.Segement) -> VerticalProgressBar {
        let multiplier = 1 / abs(fastestSegment.pace - slowestSegment.pace)
        
        return VerticalProgressBar(width: 10,
                                   height: 100,
                                   color: .green,
                                   value: CGFloat(multiplier * thisSegment.pace),
                                   text: "\(thisSegment.index)")
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            ForEach(activity.segments) { segment in
                self.bar(fastestSegment: self.activity.fastestSegement,
                         slowestSegment: self.activity.slowestSegement,
                         thisSegment: segment)
            }
        }
    }
}

struct PaceChart_Previews: PreviewProvider {
    static var previews: some View {
        PaceChart(activity: MockHelper.mockActivity)
    }
}
