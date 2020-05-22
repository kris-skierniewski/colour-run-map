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
            MapView(selectedAnnotation: .constant(nil), polylineType: .speed, mapState: .showActivityRow, recordedLocations: activity.locations)
            
            VStack(alignment: .leading) {
                Text(activity.createdAt.mwFormatted("EEEE\n dd MMMM").uppercased())
                    .padding(.horizontal)
                    .font(.system(size: 30, weight: .bold, design: Font.Design.default))
                ActivityDetails(activity: activity).padding([.top, .bottom], 10).background(BlurView())
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
        mockActivity.locations = [CLLocation(latitude: 36.063457, longitude: -95.880516),
                                  CLLocation(latitude: 36.063457, longitude: -95.980516)]
        
        return ActivityRow(activity: mockActivity)
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
