//
//  BaseFundingTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension BaseFundingTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseFundingTransactionManagedObject> {
        return NSFetchRequest<BaseFundingTransactionManagedObject>(entityName: "BaseFundingTransaction")
    }

    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var posting: PostingManagedObject?

}
