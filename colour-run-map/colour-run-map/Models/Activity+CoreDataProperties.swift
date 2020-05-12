//
//  Location+CoreDataProperties.swift
//  colour-run-map
//
//  Created by Kris Skierniewski on 12/05/2020.
//  Copyright © 2020 Kris Skierniewski. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        let sortDescriptior = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptior]
        return request
    }

    @NSManaged public var locations: [CLLocation]?
    @NSManaged public var id: String?

}
