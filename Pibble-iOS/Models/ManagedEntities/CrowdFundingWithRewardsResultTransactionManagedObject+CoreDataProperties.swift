//
//  CrowdFundingWithRewardsResultTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CrowdFundingWithRewardsResultTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrowdFundingWithRewardsResultTransactionManagedObject> {
        return NSFetchRequest<CrowdFundingWithRewardsResultTransactionManagedObject>(entityName: "CrowdFundingWithRewardsResultTransaction")
    }


}
