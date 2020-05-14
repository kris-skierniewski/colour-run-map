//
//  ActivityRow.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ActivityRow: View {
    var activity: Activity
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(showsUserLocation: false,
                    isUserInteractionEnabled: false,
                    mapState: .showCompleteRoute(activity.locations))
            
            VStack(alignment: .leading) {
                Text(activity.createdAt.mwFormatted("EEEE\n dd MMMM").uppercased())
                    .padding(.horizontal)
                    .font(.system(size: 30, weight: .bold, design: Font.Design.default))
                ActivityRowDetails(activity: activity)
            }
        }
        .frame(height: 300)
        .cornerRadius(30)
        .shadow(radius: 30)
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let mockActivity = Activity.init(context: context)
        mockActivity.createdAt = Date()
        mockActivity.distance = CLLocationDistance(1250.0)
        mockActivity.duration = TimeInterval.hourInSeconds * 1
        
        return List{
            ActivityRow(activity: mockActivity)
            ActivityRow(activity: mockActivity)
        }
    }
}

private struct ActivityRowDetails: View {
    var activity: Activity
    
    var body: some View {
        ZStack(alignment: .leading) {
            BlurView()
                .frame(height: 90)
            HStack() {
                StackedTextView(topText: "\(activity.distance.stringWithUnits)", bottomText: "distance")
                Spacer()
                StackedTextView(topText: "\(activity.duration.mwRoundedMinutesString)", bottomText: "time")
                Spacer()
                StackedTextView(topText: "\(activity.pace?.mwMinutesRounded ?? 0)", bottomText: "min/km")
            }
            .padding(.horizontal)
        }
    }
}
