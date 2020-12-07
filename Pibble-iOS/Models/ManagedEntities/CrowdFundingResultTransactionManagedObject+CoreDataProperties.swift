//
//  CrowdFundingResultTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CrowdFundingResultTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrowdFundingResultTransactionManagedObject> {
        return NSFetchRequest<CrowdFundingResultTransactionManagedObject>(entityName: "CrowdFundingResultTransaction")
    }


}
