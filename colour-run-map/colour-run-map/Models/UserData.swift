//
//  UserData.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 11/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//

import SwiftUI
import Combine
import CoreLocation

final class UserData: ObservableObject {
    @Published var isRecordingActivity = false
}
