//
//  BaseFundingDonateTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension BaseFundingDonateTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseFundingDonateTransactionManagedObject> {
        return NSFetchRequest<BaseFundingDonateTransactionManagedObject>(entityName: "BaseFundingDonateTransaction")
    }

    @NSManaged public var fromUser: UserManagedObject?

}
