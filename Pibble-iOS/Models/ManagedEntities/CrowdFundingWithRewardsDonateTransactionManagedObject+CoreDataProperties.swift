//
//  CrowdFundingWithRewardsDonateTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CrowdFundingWithRewardsDonateTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrowdFundingWithRewardsDonateTransactionManagedObject> {
        return NSFetchRequest<CrowdFundingWithRewardsDonateTransactionManagedObject>(entityName: "CrowdFundingWithRewardsDonateTransaction")
    }

    @NSManaged public var priceTitle: String?

}
