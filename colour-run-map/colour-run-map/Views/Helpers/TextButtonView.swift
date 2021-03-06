//
//  TextButtonView.swift
//  colourRun
//
//  Created by Luke on 07/05/2020.
//  Copyright © 2020 Mapway. All rights reserved.
//

import SwiftUI
import CoreLocation

struct TextButtonView: View {
    var text: String
    var backgroundColor: Color
    var tappedHandler: (() -> Void)?
    
    var body: some View {
        RoundedRectangleButton(backgroundColor: backgroundColor,
                               tappedHandler: tappedHandler) {
                                Text(text)
                                    .fontWeight(.bold)
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(1)
                                    .padding(.all, 9.0)
        }
        
    }
}

struct TextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TextButtonView(text: "Start", backgroundColor: .green)
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
