//
//  PointOfIntrest+CoreDataProperties.swift
//  Point Of Intrests
//
//  Created by chanakkya mati on 7/31/17.
//  Copyright © 2017 HimaTej. All rights reserved.
//

import Foundation
import CoreData

enum Category:String{
    case Home,Park,Bank,Hospital,School
}

extension PointOfIntrest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PointOfIntrest> {
        return NSFetchRequest<PointOfIntrest>(entityName: "PointOfIntrest")
    }

    @NSManaged public var categoryValue: String
    @NSManaged public var imageData: NSData
    @NSManaged public var infoDescription: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String
    @NSManaged public var number: Int64
    @NSManaged public var city: City
    var category:Category{
        set{
            self.categoryValue = newValue.rawValue
        }
        get{
            return Category(rawValue: self.categoryValue)!
        }
    }

}
