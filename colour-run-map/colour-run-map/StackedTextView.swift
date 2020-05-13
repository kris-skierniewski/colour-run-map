//
//  StackedTextView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct StackedTextView: View {
    
    var topText: String
    var bottomText: String
    
    var body: some View {
        VStack {
            Text(topText)
                .font(.system(size: 30, weight: .semibold, design: .default))
            Text(bottomText)
        }
    }
}

struct StackedTextView_Previews: PreviewProvider {
    static var previews: some View {
        StackedTextView(topText: "51:30", bottomText: "min/km")
    }
}
