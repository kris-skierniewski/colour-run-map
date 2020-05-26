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
    private let clockwise: Bool
    private let showPercentage: Bool
    private let showBackground: Bool
    private let textMaxDiameter: CGFloat
    
    init(color: Color = .red,
         diameter: CGFloat = 100,
         lineWidth: CGFloat = 20,
         clockwise: Bool = true,
         showPercentage: Bool = false,
         showBackground: Bool = true,
         progress: Binding<Double>) {
        self._progress = progress
        self.color = color
        self.diameter = diameter
        self.lineWidth = lineWidth
        self.clockwise = clockwise
        self.showPercentage = showPercentage
        self.showBackground = showBackground
        self.textMaxDiameter = diameter - lineWidth
    }
    
    var body: some View {
        ZStack {
            if showBackground {
                Circle()
                    .stroke(lineWidth: lineWidth)
                    .opacity(0.3)
                    .foregroundColor(color)
                    .frame(width: diameter, height: diameter, alignment: .center)
            }
            
            Circle()
                .trim(from: clockwise ? 0 : 1 - CGFloat(min(self.progress, 1.0)),
                      to: clockwise ? CGFloat(min(self.progress, 1.0)) : 1)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.easeInOut)
                .frame(width: diameter, height: diameter, alignment: .center)
            
            if showPercentage {
                Text("\((progress * 100).mwRoundTo(decimalPlaces: 0))%")
                    .font(.system(size: self.textMaxDiameter * (progress >= 1 ? 0.3 : 0.4), weight: .bold))
                    .foregroundColor(color)
                    .frame(width: self.textMaxDiameter, height: self.textMaxDiameter)
                    .clipShape(Circle())
                    .transition(.opacity)
            }
        }
        
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircularProgressBar(showPercentage: true, progress: Binding.constant(0.35))
                .padding(.all, 20)
                .previewLayout(.sizeThatFits)
            
            CircularProgressBar(color: .blue,
                                diameter: 50,
                                lineWidth: 5,
                                clockwise: false,
                                progress: .constant(0.6))
                .padding(.all, 20)
                .previewLayout(.sizeThatFits)
            
            CircularProgressBar(color: .white, showPercentage: true, progress: Binding.constant(0.45))
                .padding(.all, 20)
                .previewLayout(.sizeThatFits)
                .background(Color.black)
            
            CircularProgressBar(color: Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
                                diameter: 200,
                                lineWidth: 10,
                                clockwise: true,
                                showPercentage: false,
                                showBackground: false,
                                progress: .constant(0.7))
                .padding(.all, 20)
                .previewLayout(.sizeThatFits)
        }
    }
}
