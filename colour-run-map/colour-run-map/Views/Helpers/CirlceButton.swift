//
//  CirlceButton.swift
//  colour-run-map
//
//  Created by Luke on 22/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct CirlceButton<ContentView: View>: View {
    private var content: ContentView
    
    private var diameter: CGFloat
    private var backgroundColor: Color
    private var tappedHandler: (() -> Void)?
    
    public init(diameter: CGFloat,
                backgroundColor: Color,
                tappedHandler: (() -> Void)?,
                @ViewBuilder content: () -> ContentView) {
        self.diameter = diameter
        self.backgroundColor = backgroundColor
        self.tappedHandler = tappedHandler
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            self.tappedHandler?()
        }, label: { self.content } )
            .frame(width: diameter, height: diameter, alignment: .center)
            .background(self.backgroundColor)
            
        .clipShape(Circle())
    }
}

struct CirlceButton_Previews: PreviewProvider {
    static var previews: some View {
        CirlceButton(diameter: 150,
                     backgroundColor: .red,
                     tappedHandler: nil,
                     content: { Text("Start")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .padding(.all, 9.0) })
        .previewLayout(.sizeThatFits)
        .padding(10)
        .fixedSize(horizontal: false, vertical: false)
    }
}
