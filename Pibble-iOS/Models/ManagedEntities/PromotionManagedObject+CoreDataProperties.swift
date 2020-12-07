//
//  PromotionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PromotionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PromotionManagedObject> {
        return NSFetchRequest<PromotionManagedObject>(entityName: "Promotion")
    }

    @NSManaged public var actionTitle: String?
    @NSManaged public var budget: NSDecimalNumber?
    @NSManaged public var destination: String?
    @NSManaged public var destinationUrl: String?
    @NSManaged public var duration: Int32
    @NSManaged public var expirationDate: NSDate?
    @NSManaged public var id: Int32
    @NSManaged public var status: String?
    @NSManaged public var posting: PostingManagedObject?

}
