//
//  BaseInternalTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension BaseInternalTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseInternalTransactionManagedObject> {
        return NSFetchRequest<BaseInternalTransactionManagedObject>(entityName: "BaseInternalTransaction")
    }

    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var toUser: UserManagedObject?

}
