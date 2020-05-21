//
//  ActivitySegmentView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 19/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct ActivitySegmentView: View {
    var annotation: ActivityAnnotation
    
    
    var body: some View {
        VStack{
            if annotation.segment != nil {
                VStack{
                    Text("\(annotation.title!) Split")
                        .font(.title).bold()
                        .padding()
                    Text("Pace: \(PaceHelper.calculatePace(distance: 1000, start: annotation.segment!.first!.timestamp, end: annotation.segment!.last!.timestamp).asString) min/km")
                }
                
            }
            
        }
        
        
    }
    
    
    
    
}

struct ActivitySegmentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitySegmentView(annotation: ActivityAnnotation())
    }
}
