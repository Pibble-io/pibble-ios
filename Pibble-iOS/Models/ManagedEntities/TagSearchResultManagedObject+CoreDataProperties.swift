//
//  TagSearchResultManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension TagSearchResultManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagSearchResultManagedObject> {
        return NSFetchRequest<TagSearchResultManagedObject>(entityName: "TagSearchResult")
    }

    @NSManaged public var relatedTag: TagManagedObject?

}
