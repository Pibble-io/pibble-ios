//
//  CharityFundingDonateTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CharityFundingDonateTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharityFundingDonateTransactionManagedObject> {
        return NSFetchRequest<CharityFundingDonateTransactionManagedObject>(entityName: "CharityFundingDonateTransaction")
    }


}
