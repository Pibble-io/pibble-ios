//
//  CharityFundingResultTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension CharityFundingResultTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharityFundingResultTransactionManagedObject> {
        return NSFetchRequest<CharityFundingResultTransactionManagedObject>(entityName: "CharityFundingResultTransaction")
    }


}
