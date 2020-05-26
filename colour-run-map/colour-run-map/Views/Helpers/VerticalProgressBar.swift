//
//  VerticalProgressBar.swift
//  colour-run-map
//
//  Created by Luke on 26/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct VerticalProgressBar: View {
    
    var width: CGFloat
    var height: CGFloat
    var color: Color
    
    var value: CGFloat
    var text: String
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                Capsule(style: .continuous)
                    .frame(width: width, height: height)
                    .foregroundColor(color)
                    .opacity(0.2)
                Capsule()
                    .frame(width: width, height: height * value)
                    .foregroundColor(color)
                    .animation(.spring())
            }
            Text(text)
        }
    }
}

struct VerticalProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VerticalProgressBar(width: 20, height: 100, color: .green, value: 0.45, text: "A")
            .previewLayout(.sizeThatFits)
            .padding(20)
    }
}
