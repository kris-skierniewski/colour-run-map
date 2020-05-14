//
//  ActivityDetailView.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 13/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct ActivityDetailView: View {
    
    var activity: Activity
    
    var body: some View {
        ZStack {
            MapView(showsUserLocation: false,
                    mapState: Binding.constant(MapState.showCompleteRoute(activity.locations)))
                .edgesIgnoringSafeArea(.all)
            CardView(height: 400) {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct ActivityDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let mockActivity = Activity.init(context: context)
        mockActivity.createdAt = Date()
        mockActivity.locations = []
        
        return ActivityDetailView(activity: mockActivity)
    }
}


