//
//  CommerceManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CommerceManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommerceManagedObject> {
        return NSFetchRequest<CommerceManagedObject>(entityName: "Commerce")
    }

    @NSManaged public var createdAt: String?
    @NSManaged public var discount: Int32
    @NSManaged public var errorCode: String?
    @NSManaged public var id: Int32
    @NSManaged public var isCommercialUse: Bool
    @NSManaged public var isDownloadable: Bool
    @NSManaged public var isEditorialUse: Bool
    @NSManaged public var isExclusiveUse: Bool
    @NSManaged public var isRoyaltyFreeUse: Bool
    @NSManaged public var limit: Int32
    @NSManaged public var price: NSDecimalNumber?
    @NSManaged public var reward: Double
    @NSManaged public var status: String?
    @NSManaged public var title: String?
    @NSManaged public var post: PostingManagedObject?

}
