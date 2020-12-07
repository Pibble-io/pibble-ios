//
//  AirdropTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension AirdropTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirdropTransactionManagedObject> {
        return NSFetchRequest<AirdropTransactionManagedObject>(entityName: "AirdropTransaction")
    }

    @NSManaged public var value: NSDecimalNumber?

}
