//
//  BaseSearchResultManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension BaseSearchResultManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseSearchResultManagedObject> {
        return NSFetchRequest<BaseSearchResultManagedObject>(entityName: "BaseSearchResult")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var resultType: Int32
    @NSManaged public var searchKey: String?

}
