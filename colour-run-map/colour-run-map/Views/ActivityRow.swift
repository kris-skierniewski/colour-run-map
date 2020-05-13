//
//  ActivityRow.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct ActivityRow: View {
    
    var activity: Activity
    
    var formatter = Formatter()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(showsUserLocation: false, isUserInteractionEnabled: false, recordedLocations: activity.locations)
            VStack(alignment: .leading) {
                Text(formatter.dayString(from: activity.createdAt).uppercased())
                    .padding(.horizontal)
                    .font(.system(size: 35, weight: .bold, design: Font.Design.default))
                ZStack(alignment: .leading) {
                    BlurView().frame(height: 150)
                    HStack() {
                        //Spacer()
                        StackedTextView(topText: "6.65", bottomText: "km")
                        Spacer()
                        StackedTextView(topText: "52:43", bottomText: "time")
                        Spacer()
                        StackedTextView(topText: "8:31", bottomText: "min/km")
                        //Spacer()
                    }.padding(.horizontal)
                    
                }
            }
            
            
        }
        .frame(height: 400)
        .cornerRadius(30)
        .shadow(radius: 30)
        
        
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        ActivityRow(activity: Activity())
    }
}
