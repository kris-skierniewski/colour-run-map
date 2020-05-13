//
//  SideMenuView.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct SideMenuView: View {
    let width: CGFloat
    let isMenuOpen: Bool
    let menuCloseAction: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.3))
            .opacity(isMenuOpen ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .edgesIgnoringSafeArea(.all)
            .onTapGesture { self.menuCloseAction() }
            
            HStack {
                MenuContentView()
                    .frame(width: self.width)
                    .background(Color.white)
                    .offset(x: self.isMenuOpen ? 0 : -self.width)
                    .animation(.default)
                
                Spacer()
            }
        }
    }
}


struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(width: 300, isMenuOpen: true, menuCloseAction: { })
    }
}
