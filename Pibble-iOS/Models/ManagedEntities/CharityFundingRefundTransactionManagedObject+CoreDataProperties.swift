//
//  CharityFundingRefundTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CharityFundingRefundTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharityFundingRefundTransactionManagedObject> {
        return NSFetchRequest<CharityFundingRefundTransactionManagedObject>(entityName: "CharityFundingRefundTransaction")
    }


}
