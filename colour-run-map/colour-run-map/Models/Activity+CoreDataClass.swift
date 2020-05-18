//
//  Location+CoreDataClass.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//
//

import Foundation
import CoreData


public class Activity: NSManagedObject, Identifiable {

    var pace: TimeInterval {
        let pace = PaceHelper.calculatePace(distance: distance,
                                            start: createdAt,
                                            end: createdAt.addingTimeInterval(duration))
        return pace
        //return pace.isInfinite || pace.isNaN ? nil : pace
    }
    
}
