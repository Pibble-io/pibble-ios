//
//  PostHelpRewardTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension PostHelpRewardTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostHelpRewardTransactionManagedObject> {
        return NSFetchRequest<PostHelpRewardTransactionManagedObject>(entityName: "PostHelpRewardTransaction")
    }


}
