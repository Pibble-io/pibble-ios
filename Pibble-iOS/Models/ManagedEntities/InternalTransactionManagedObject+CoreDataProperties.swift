//
//  InternalTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension InternalTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InternalTransactionManagedObject> {
        return NSFetchRequest<InternalTransactionManagedObject>(entityName: "InternalTransaction")
    }


}
