//
//  MenuContentView.swift
//  colour-run-map
//
//  Created by Luke on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct MenuContentView: View {
    
    private var menu: Menu = Menu(items: [MenuItem(image: Image(systemName: "book"),
                                                   title: "Activities",
                                                   tapHandler: {
                                                    print("activities")
    })])
    
    var body: some View {
        List(menu.items) { item in
            MenuContentRowView(menuItem: item)
        }.listStyle(PlainListStyle())
    }
}

struct MenuContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuContentView()
    }
}

struct MenuContentRowView: View {
    var menuItem: MenuItem
    
    var body: some View {
        Button(action: {
            self.menuItem.tapHandler?()
        }, label: {
            HStack {
                menuItem.image
                    .frame(width: 30, height: 30, alignment: .center)
                Text(menuItem.title)
            }
        })
    }
}

struct MenuItem: Identifiable {
    
    let id = UUID()
    var image: Image
    var title: String
    var tapHandler: (() -> Void)?
    
    init(image: Image, title: String, tapHandler: (() -> Void)? = nil) {
        self.image = image
        self.title = title
        self.tapHandler = tapHandler
    }
    
}

struct Menu {
    
    var items: [MenuItem]
    
    init(items: [MenuItem]) {
        self.items = items
    }
    
}
