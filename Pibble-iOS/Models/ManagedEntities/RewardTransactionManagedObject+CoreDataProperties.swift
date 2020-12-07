//
//  RewardTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension RewardTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RewardTransactionManagedObject> {
        return NSFetchRequest<RewardTransactionManagedObject>(entityName: "RewardTransaction")
    }

    @NSManaged public var rewardType: String?
    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var toUser: UserManagedObject?

}
