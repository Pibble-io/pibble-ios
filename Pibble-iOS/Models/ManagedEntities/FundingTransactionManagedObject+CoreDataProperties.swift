//
//  FundingTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension FundingTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FundingTransactionManagedObject> {
        return NSFetchRequest<FundingTransactionManagedObject>(entityName: "FundingTransaction")
    }

    @NSManaged public var value: NSDecimalNumber?
    @NSManaged public var fromUser: UserManagedObject?
    @NSManaged public var posting: PostingManagedObject?

}
