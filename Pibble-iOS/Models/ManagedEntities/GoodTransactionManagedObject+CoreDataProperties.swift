//
//  GoodTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension GoodTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoodTransactionManagedObject> {
        return NSFetchRequest<GoodTransactionManagedObject>(entityName: "GoodTransaction")
    }

    @NSManaged public var fee: NSDecimalNumber?
    @NSManaged public var goodsTransactionType: String?
    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var post: PostingManagedObject?
    @NSManaged public var toUser: UserManagedObject?

}
