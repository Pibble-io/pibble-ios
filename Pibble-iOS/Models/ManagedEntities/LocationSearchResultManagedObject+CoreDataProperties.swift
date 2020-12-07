//
//  LocationSearchResultManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension LocationSearchResultManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationSearchResultManagedObject> {
        return NSFetchRequest<LocationSearchResultManagedObject>(entityName: "LocationSearchResult")
    }

    @NSManaged public var relatedLocation: LocationManagedObject?

}
