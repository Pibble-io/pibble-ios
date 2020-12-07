//
//  DigitalGoodTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension DigitalGoodTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DigitalGoodTransactionManagedObject> {
        return NSFetchRequest<DigitalGoodTransactionManagedObject>(entityName: "DigitalGoodTransaction")
    }

    @NSManaged public var fee: NSDecimalNumber?
    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var post: PostingManagedObject?
    @NSManaged public var toUser: UserManagedObject?

}
