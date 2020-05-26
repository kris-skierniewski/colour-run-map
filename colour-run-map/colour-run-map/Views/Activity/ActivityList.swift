//
//  ActivityList.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct ActivityList: View {
    
    @State private var isShowingActivityDetailView = false
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @EnvironmentObject var userData: UserData
    
    @FetchRequest(fetchRequest: Activity.fetchRequest()) private var activities: FetchedResults<Activity>
    
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
            }
        }
    }
}

struct ActivityList_Previews: PreviewProvider {
    static var previews: some View {
        return ActivityList()
            .environment(\.managedObjectContext, MockHelper.mockContext)
            .environmentObject(UserData())
    }
}
