//
//  WalletActivityManagedObject+CoreDataProperties.swift
//  
//
//  Created by Sergey Kazakov on 05/10/2019.
//
//

import Foundation
import CoreData


extension WalletActivityManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletActivityManagedObject> {
        return NSFetchRequest<WalletActivityManagedObject>(entityName: "WalletActivity")
    }

    @NSManaged public var activityType: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var createdAtDate: NSDate?
    @NSManaged public var currency: String?
    @NSManaged public var id: Int32
    @NSManaged public var isBrushCurrencyType: Bool
    @NSManaged public var isCoinCurrencyType: Bool
    @NSManaged public var isHidden: Bool
    @NSManaged public var user: UserManagedObject?

}
