//
//  PostHelpTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PostHelpTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostHelpTransactionManagedObject> {
        return NSFetchRequest<PostHelpTransactionManagedObject>(entityName: "BasePostHelpTransaction")
    }


}
