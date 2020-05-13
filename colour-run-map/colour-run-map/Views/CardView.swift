//
//  CardView.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

public struct CardView<ContentView: View>: View {
    
    @Binding var isPresented: Bool
    
    @State private var height: CGFloat = 200
    
    private let content: ContentView
    
    private let topBarHeight: CGFloat = 30
    private var maxHeight: CGFloat = UIScreen.main.bounds.size.height * 0.8
    private var minHeight: CGFloat = UIScreen.main.bounds.size.height * 0.2
    
    public init(isPresented: Binding<Bool>,
                height: CGFloat,
                topBarBackgroundColor: Color = Color(.systemBackground),
                contentBackgroundColor: Color = Color(.systemBackground),
                @ViewBuilder content: () -> ContentView) {
        self._isPresented = isPresented
        self._height = State(initialValue: height)
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.topBar(geometry: geometry)
                VStack {
                    self.content
                        .padding(.top, geometry.safeAreaInsets.bottom)
                    Spacer()
                }
            }
            .frame(height: self.height)
            .background(Color(.systemBackground))
            .cornerRadius(self.topBarHeight/3, corners: [.topLeft, .topRight])
            .animation(.linear)
            .offset(y: geometry.size.height/2 - self.height/2 + geometry.safeAreaInsets.bottom)
        }
    }
    
    fileprivate func topBar(geometry: GeometryProxy) -> some View {
        ZStack {
            Capsule()
                .frame(width: 200, height: 10)
                .foregroundColor(Color.secondary)
        }
        .frame(width: geometry.size.width, height: self.topBarHeight)
        .background(Color(.systemBackground))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    let offsetY = value.translation.height
                    let newHeight = self.height - offsetY
                    if (newHeight > self.minHeight) &&
                        (newHeight < self.maxHeight) {
                        self.height -= offsetY
                    }
                })
        )
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(isPresented: Binding.constant(true), height: 400, content: {  TestContent() }).background(Color.black)

    }
}

protocol CardContentProtocol {
    var minHeight: CGFloat { get }

    var maxHeight: CGFloat { get }
}

struct TestContent: View, CardContentProtocol {
    var minHeight: CGFloat { return 100 }

    var maxHeight: CGFloat { return 200 }

    var body: some View {
        Text("Banana")
    }
}
