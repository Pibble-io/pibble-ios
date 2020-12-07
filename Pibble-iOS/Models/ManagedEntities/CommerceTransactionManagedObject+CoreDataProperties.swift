//
//  CommerceTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CommerceTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommerceTransactionManagedObject> {
        return NSFetchRequest<CommerceTransactionManagedObject>(entityName: "CommerceTransaction")
    }

    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var post: PostingManagedObject?

}
