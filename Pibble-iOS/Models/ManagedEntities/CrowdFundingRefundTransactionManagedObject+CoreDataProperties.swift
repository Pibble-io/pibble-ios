//
//  CrowdFundingRefundTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CrowdFundingRefundTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrowdFundingRefundTransactionManagedObject> {
        return NSFetchRequest<CrowdFundingRefundTransactionManagedObject>(entityName: "CrowdFundingRefundTransaction")
    }


}
