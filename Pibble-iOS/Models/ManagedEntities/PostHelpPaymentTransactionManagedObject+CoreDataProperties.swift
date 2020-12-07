//
//  PostHelpPaymentTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PostHelpPaymentTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostHelpPaymentTransactionManagedObject> {
        return NSFetchRequest<PostHelpPaymentTransactionManagedObject>(entityName: "PostHelpPaymentTransaction")
    }


}
