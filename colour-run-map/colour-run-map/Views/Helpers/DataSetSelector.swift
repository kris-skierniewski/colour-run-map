//
//  DataSetSelector.swift
//  colour-run-map
//
//  Created by Luke on 22/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI

struct DataSetSelector: View {
    
    @Binding var selectedState: DataSet
    
    @State private var selfSelectedState: DataSet
    
    init(selectedState: Binding<DataSet>) {
        self._selectedState = selectedState
        self._selfSelectedState = State(initialValue: selectedState.wrappedValue)
    }
    
    var body: some View {
        VStack {
            ImageButtonView(image: DataSet.speed.icon,
                            backgroundColor: $selfSelectedState.wrappedValue == .speed ? .green : .blue) {
                                self.selectedState = .speed
                                self.selfSelectedState = .speed
            }
            
            ImageButtonView(image: DataSet.altitude.icon,
                            backgroundColor: $selfSelectedState.wrappedValue == .altitude ? .green : .blue) {
                                self.selectedState = .altitude
                                self.selfSelectedState = .altitude
            }
        }
    }
}

struct DataSetSelector_Previews: PreviewProvider {
    static var previews: some View {
        DataSetSelector(selectedState: Binding.constant(.speed))
        .previewLayout(.sizeThatFits)
        .padding(10)
    }
}
