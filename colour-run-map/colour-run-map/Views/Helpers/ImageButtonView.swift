//
//  ImageButtonView.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct ImageButtonView: View {
    @State var image: Image
    @State var backgroundColor: Color
    @State var tappedHandler: (() -> Void)?
    
    var body: some View {
        RoundedRectangleButton(backgroundColor: backgroundColor,
                               tappedHandler: tappedHandler,
                               content: {
                                image
                                    .foregroundColor(Color.white)
                                    .padding(.all, 10.0)
        })
    }
}

struct ImageButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ImageButtonView(image: Image(systemName: "book.fill"),
                        backgroundColor: .purple)
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
