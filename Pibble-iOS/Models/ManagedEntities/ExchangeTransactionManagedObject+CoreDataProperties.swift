//
//  ExchangeTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension ExchangeTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeTransactionManagedObject> {
        return NSFetchRequest<ExchangeTransactionManagedObject>(entityName: "ExchangeTransaction")
    }

    @NSManaged public var exchangeCurrencyRate: Double
    @NSManaged public var fromAmount: NSDecimalNumber?
    @NSManaged public var fromCurrency: String?
    @NSManaged public var toAmount: NSDecimalNumber?
    @NSManaged public var toCurrency: String?

}
