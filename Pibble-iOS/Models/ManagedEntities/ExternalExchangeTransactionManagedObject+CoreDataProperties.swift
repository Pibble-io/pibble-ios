//
//  ExternalExchangeTransactionManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension ExternalExchangeTransactionManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExternalExchangeTransactionManagedObject> {
        return NSFetchRequest<ExternalExchangeTransactionManagedObject>(entityName: "ExternalExchangeTransaction")
    }

    @NSManaged public var exchangeCurrencyRate: Double
    @NSManaged public var fromAmount: NSDecimalNumber?
    @NSManaged public var fromAppName: String?
    @NSManaged public var fromCurrency: String?
    @NSManaged public var fromCurrencyIconUrlString: String?
    @NSManaged public var fromCurrencyName: String?
    @NSManaged public var toAmount: NSDecimalNumber?
    @NSManaged public var toCurrency: String?

}
