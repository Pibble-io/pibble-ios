//
//  PromotionTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PromotionTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PromotionTransactionManagedObject> {
        return NSFetchRequest<PromotionTransactionManagedObject>(entityName: "PromotionTransaction")
    }

    @NSManaged public var promotionType: String?
    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var toUser: UserManagedObject?

}
