//
//  BlurView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .regular
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        
        ZStack {
            Color.black
            TextButtonView(text: "TEST", backgroundColor: .orange, tappedHandler: nil)
            GeometryReader { geo in
                VStack {
                    Spacer().frame(height: geo.size.height / 2)
                    BlurView()
                }
            }
        }
    }
}
