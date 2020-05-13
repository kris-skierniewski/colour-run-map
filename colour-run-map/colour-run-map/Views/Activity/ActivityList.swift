//
//  ActivityList.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct ActivityList: View {
    
    //var activities: [Activity]
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: Activity.fetchRequest()) var activities: FetchedResults<Activity>
    @EnvironmentObject var userData: UserData
    @State var isShowingMap = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                        ForEach(activities) { activity in
                            NavigationLink(destination: ActivityDetailView(activity: activity)) {
                                ActivityRow(activity: activity).padding()
                            }
                        .buttonStyle(PlainButtonStyle())
                        }
                    }
                .navigationBarTitle("Activities")
                .sheet(isPresented: $isShowingMap) {
                    ContentView()
                        .environment(\.managedObjectContext, self.managedObjectContext)
                        .environmentObject(self.userData)
                }
                TextButtonView(text: "New Activity", backgroundColor: .blue, tappedHandler: { self.isShowingMap = true })
            }
            
        }
        
    }
}

struct ActivityList_Previews: PreviewProvider {
    static var previews: some View {
        ActivityList()
    }
}
