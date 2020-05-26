//
//  BottomCardContainer.swift
//  colour-run-map
//
//  Created by Luke on 26/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct BottomCardContainer<ContentView: View>: View {
    
    @Binding var bottomCardHeightOffset: CGFloat
    
    private let bottomCardMaxHeightOffset: CGFloat = screenSize.height * 0.1
    private let bottomCardHiddenHeightOffset: CGFloat = screenSize.height
    private let bottomCardMinimumHeightOffset: CGFloat = screenSize.height * 0.8
    
    @State private var bottomCardModifiedHeightOffset: CGFloat = 0
    
    private let cardContent: ContentView
    
    public init(bottomCardHeightOffset: Binding<CGFloat>, @ViewBuilder content: () -> ContentView) {
        self._bottomCardHeightOffset = bottomCardHeightOffset
        self.cardContent = content()
    }
    
    var body: some View {
        ZStack {
//            Color.white.opacity( bottomCardOrigionalHeightOffset + bottomCardModifiedHeightOffset > bottomCardMinimumHeightOffset ? 0.00001 : 0)
//                .onTapGesture {
//                    self.bottomCardModifiedHeightOffset = .zero
//                    self.bottomCardOrigionalHeightOffset = 550
//            }
            
            BottomCard() {
                cardContent
            }
                .offset(y: bottomCardHeightOffset)
                .offset(y: bottomCardModifiedHeightOffset)
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                .gesture(
                    DragGesture()
                        .onChanged({
                            self.bottomCardModifiedHeightOffset = $0.translation.height
                        })
                        .onEnded({ _ in
                            let newHeight: CGFloat = self.bottomCardHeightOffset + self.bottomCardModifiedHeightOffset
                            
                            if newHeight > 700 { self.bottomCardHeightOffset = self.bottomCardHiddenHeightOffset } // hide card
                            else { self.bottomCardHeightOffset = newHeight }
                            
                            self.bottomCardModifiedHeightOffset = 0
                        })
            )
        }
    }
}


struct BottomCardContainer_Previews: PreviewProvider {
    static var previews: some View {
        BottomCardContainer(bottomCardHeightOffset: .constant(450)) {
            Text("Sample Content").foregroundColor(.red)
        }
            .background(Color.black)
    }
}
