//
//  GoodsManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension GoodsManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoodsManagedObject> {
        return NSFetchRequest<GoodsManagedObject>(entityName: "Goods")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int32
    @NSManaged public var isNewState: Bool
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var site: String?
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var uuid: String?
    @NSManaged public var post: PostingManagedObject?

}
