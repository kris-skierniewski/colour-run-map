//
//  RoundedRectangleButton.swift
//  colour-run-map
//
//  Created by Luke on 22/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct RoundedRectangleButton<ContentView: View>: View {
    
    private var content: ContentView
    
    private var backgroundColor: Color
    private var tappedHandler: (() -> Void)?
    
    public init(backgroundColor: Color,
                tappedHandler: (() -> Void)?,
                @ViewBuilder content: () -> ContentView) {
        self.backgroundColor = backgroundColor
        self.tappedHandler = tappedHandler
        self.content = content()
    }
    
    var body: some View {
        Button(action: {
            self.tappedHandler?()
        }, label: { self.content } )
            .background(self.backgroundColor)
            .cornerRadius(10, corners: .allCorners)
    }
}

struct RoundedRectangleButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangleButton(backgroundColor: Color.red,
                               tappedHandler: nil) {
                                Text("text")
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .padding(.all, 9.0)
        }
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
