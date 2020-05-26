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
        return ActivityRow(activity: MockHelper.mockActivity)
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
