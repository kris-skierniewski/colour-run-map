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
    @Binding var isVisible: Bool
    
    private let bottomCardMaxHeightOffset: CGFloat = screenSize.height * 0.3
    private let bottomCardHiddenHeightOffset: CGFloat = screenSize.height
    private let bottomCardMinimumHeightOffset: CGFloat = screenSize.height * 0.75
    
    @State private var bottomCardModifiedHeightOffset: CGFloat = 0
    
    private let cardContent: ContentView
    
    public init(bottomCardHeightOffset: Binding<CGFloat>, isVisible: Binding<Bool>,
                @ViewBuilder content: () -> ContentView) {
        self._bottomCardHeightOffset = bottomCardHeightOffset
        self._isVisible = isVisible
        self.cardContent = content()
    }
    
    var body: some View {
        ZStack {
            if isVisible {
                BottomCard() {
                    cardContent
                }
                .offset(y: bottomCardHeightOffset)
                .offset(y: bottomCardModifiedHeightOffset)
                .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration: 0.8))
                .opacity(self.bottomCardHeightOffset + self.bottomCardModifiedHeightOffset > self.bottomCardMinimumHeightOffset ? 0.4  : 1)
                .gesture(
                    DragGesture()
                        .onChanged({
                            let newHeight: CGFloat = self.bottomCardHeightOffset + $0.translation.height
                            if newHeight < self.bottomCardMaxHeightOffset {
                                self.bottomCardModifiedHeightOffset = 0
                                self.bottomCardHeightOffset = self.bottomCardMaxHeightOffset
                            } else {
                                self.bottomCardModifiedHeightOffset = $0.translation.height
                            }
                        })
                        .onEnded({ _ in
                            let newHeight: CGFloat = self.bottomCardHeightOffset + self.bottomCardModifiedHeightOffset
                            
                            if newHeight > self.bottomCardMinimumHeightOffset {
                                self.isVisible = false
                                self.bottomCardModifiedHeightOffset = 0
                                self.bottomCardHeightOffset = 450
                            } else if newHeight < self.bottomCardMaxHeightOffset {
                                self.bottomCardHeightOffset = self.bottomCardMaxHeightOffset
                            } else {
                                self.bottomCardHeightOffset = newHeight
                            }
                            
                            self.bottomCardModifiedHeightOffset = 0
                        })
                )
            }
        }
    }
}


struct BottomCardContainer_Previews: PreviewProvider {
    static var previews: some View {
        BottomCardContainer(bottomCardHeightOffset: .constant(450),
                            isVisible: .constant(true)) {
                                Text("Sample Content").foregroundColor(.red)
        }
        .background(Color.black)
    }
}
