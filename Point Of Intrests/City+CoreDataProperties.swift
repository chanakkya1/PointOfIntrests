//
//  City+CoreDataProperties.swift
//  Point Of Intrests
//
//  Created by chanakkya mati on 7/31/17.
//  Copyright © 2017 HimaTej. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var name: String

}
