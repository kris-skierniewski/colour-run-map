//
//  TabBarView.swift
//  colour-run-map
//
//  Created by Luke on 13/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Activity.fetchRequest()) var activities: FetchedResults<Activity>
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        TabView {
            ActivityList()
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(UserData())
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Activities")
                }.tag(0)
            ContentView()
                .environment(\.managedObjectContext, self.managedObjectContext)
                .environmentObject(self.userData)
                .tabItem {
                    Image(systemName: "pin")
                    Text("Now")
                }.tag(1)
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
