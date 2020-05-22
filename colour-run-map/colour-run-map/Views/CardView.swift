//
//  CardView.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

public struct CardView<ContentView: View>: View {
    
    @Binding var height: CGFloat
    
    private let content: ContentView
    
    private let topBarHeight: CGFloat = 30
    private var maxHeight: CGFloat = UIScreen.main.bounds.size.height * 0.7
    private var minHeight: CGFloat = UIScreen.main.bounds.size.height * 0.2
    
    public init(height: Binding<CGFloat>,
                @ViewBuilder content: () -> ContentView) {
        self._height = height
        self.content = content()
    }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.topBar(geometry: geometry)
                VStack {
                    self.content
                        //.padding(.top, geometry.safeAreaInsets.bottom)
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let mockActivity = Activity.init(context: context)
        mockActivity.createdAt = Date()
        mockActivity.locations = [CLLocation(latitude: 36.063457, longitude: -95.880516),
                                  CLLocation(latitude: 36.063457, longitude: -95.980516)]
        return CardView(height: Binding.constant(400),
                        content: { ActivityDetails(activity: mockActivity) })
            .background(Color.black)
    }
}
