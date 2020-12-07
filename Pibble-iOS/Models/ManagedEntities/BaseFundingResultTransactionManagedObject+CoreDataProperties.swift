//
//  BaseFundingResultTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension BaseFundingResultTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseFundingResultTransactionManagedObject> {
        return NSFetchRequest<BaseFundingResultTransactionManagedObject>(entityName: "BaseFundingResultTransaction")
    }

    @NSManaged public var isSuccess: Bool
    @NSManaged public var value: NSDecimalNumber?

}
