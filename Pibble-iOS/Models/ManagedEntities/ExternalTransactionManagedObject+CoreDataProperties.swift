//
//  ExternalTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension ExternalTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExternalTransactionManagedObject> {
        return NSFetchRequest<ExternalTransactionManagedObject>(entityName: "ExternalTransaction")
    }

    @NSManaged public var fromAddress: String?
    @NSManaged public var toAddress: String?
    @NSManaged public var transactionHash: String?
    @NSManaged public var value: NSDecimalNumber?

}
