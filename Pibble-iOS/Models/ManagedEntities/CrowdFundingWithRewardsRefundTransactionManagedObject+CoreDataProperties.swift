//
//  CrowdFundingWithRewardsRefundTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CrowdFundingWithRewardsRefundTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrowdFundingWithRewardsRefundTransactionManagedObject> {
        return NSFetchRequest<CrowdFundingWithRewardsRefundTransactionManagedObject>(entityName: "CrowdFundingWithRewardsRefundTransaction")
    }


}
