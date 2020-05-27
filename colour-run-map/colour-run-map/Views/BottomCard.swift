//
//  BottomCard.swift
//  colour-run-map
//
//  Created by Luke on 26/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

let screenSize = UIScreen.main.bounds

struct BottomCard<ContentView: View>: View {
    
    private let content: ContentView
    
    public init(@ViewBuilder content: () -> ContentView) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Spacer()
                Capsule(style: .circular)
                    .frame(width: 80, height: 6)
                    .opacity(0.1)
                Spacer()
            }
            content
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(radius: 20)
    }
}

struct BottomCard_Previews: PreviewProvider {
    static var previews: some View {
        BottomCard() {
            VStack {
                Text("Sample Content")
                Text("Sample Content")
                Text("Sample Content")
                Text("Sample Content")
            }
        }
        .offset(x: 0, y : 500)
    }
}


