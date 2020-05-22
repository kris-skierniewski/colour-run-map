//
//  CircularProgressBar.swift
//  colour-run-map
//
//  Created by Luke on 22/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct CircularProgressBar: View {
    @Binding var progress: Double
    
    private let color: Color
    private let diameter: CGFloat
    private let lineWidth: CGFloat
    
    init(color: Color = .red, diameter: CGFloat = 100, lineWidth: CGFloat = 20, progress: Binding<Double>) {
        self._progress = progress
        self.color = color
        self.diameter = diameter
        self.lineWidth = lineWidth
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(color)
                .frame(width: diameter, height: diameter, alignment: .center)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            .frame(width: diameter, height: diameter, alignment: .center)
        }
        
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(progress: Binding.constant(0.3))
            .padding(.all, 20)
            .previewLayout(.sizeThatFits)
    }
}
