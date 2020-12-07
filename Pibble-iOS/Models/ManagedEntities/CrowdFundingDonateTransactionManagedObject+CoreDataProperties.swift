//
//  CrowdFundingDonateTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CrowdFundingDonateTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CrowdFundingDonateTransactionManagedObject> {
        return NSFetchRequest<CrowdFundingDonateTransactionManagedObject>(entityName: "CrowdFundingDonateTransaction")
    }


}
